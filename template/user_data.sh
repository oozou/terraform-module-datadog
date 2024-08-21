#!/bin/bash -x

sudo yum update -y
sudo yum -y install wget
if [[ "$(python3 -V 2>&1)" =~ ^(Python 3.6.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.6/get-pip.py -O /tmp/get-pip.py
elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.5.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.5/get-pip.py -O /tmp/get-pip.py
elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.4.*) ]]; then
    sudo wget https://bootstrap.pypa.io/pip/3.4/get-pip.py -O /tmp/get-pip.py
else
    sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
fi
sudo python3 /tmp/get-pip.py
sudo /usr/local/bin/pip3 install botocore
sudo yum update -y
sudo yum install -y aws-cli jq

sudo aws configure set region ${region}

curl https://packages.microsoft.com/config/rhel/9/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo
sudo yum remove unixODBC-utf16 unixODBC-utf16-devel #to avoid conflicts
sudo ACCEPT_EULA=Y yum install -y msodbcsql18
# optional: for bcp and sqlcmd
sudo ACCEPT_EULA=Y yum install -y mssql-tools18
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
# optional: for unixODBC development headers
sudo yum install -y unixODBC-devel

# Fetch the secret value from AWS Secrets Manager
SECRET=$(aws secretsmanager get-secret-value --secret-id ${secret-id} --query SecretString --output text)

DD_API_KEY=$(echo $SECRET | jq -r .DD_API_KEY)
DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=$DD_API_KEY DD_SITE="ap1.datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)"

sudo aws s3 cp ${s3}/odbc.ini /opt/datadog-agent/embedded/etc/odbc.ini
sudo aws s3 cp ${s3}/odbcinst.ini /opt/datadog-agent/embedded/etc/odbcinst.ini
sudo aws s3 cp ${s3}/conf.yaml /etc/datadog-agent/conf.d/sqlserver.d
sudo cp -p /etc/datadog-agent/conf.d/sqlserver.d/conf.yaml /etc/datadog-agent/conf.d/sqlserver.d/conf.yaml.template

PASSWORD=$(echo $SECRET | jq -r .rds_credentials)
RDS_PASSWORD=$PASSWORD

# Escape special characters in RDS_PASSWORD
ESCAPED_PASSWORD=$(printf '%s\n' "$RDS_PASSWORD" | sed -e 's/[\/&]/\\&/g')
# Ensure the template file exists and perform the substitution
if [ -f /etc/datadog-agent/conf.d/sqlserver.d/conf.yaml.template ]; then
  sed "s/{{RDS_PASSWORD}}/$ESCAPED_PASSWORD/" /etc/datadog-agent/conf.d/sqlserver.d/conf.yaml.template > /etc/datadog-agent/conf.d/sqlserver.d/conf.yaml
else
  echo "Template file not found."
fi

sudo systemctl restart datadog-agent