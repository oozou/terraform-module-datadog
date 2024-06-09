# #!/bin/bash -x

# sudo yum update -y
# sudo yum -y install wget
# if [[ "$(python3 -V 2>&1)" =~ ^(Python 3.6.*) ]]; then
#     sudo wget https://bootstrap.pypa.io/pip/3.6/get-pip.py -O /tmp/get-pip.py
# elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.5.*) ]]; then
#     sudo wget https://bootstrap.pypa.io/pip/3.5/get-pip.py -O /tmp/get-pip.py
# elif [[ "$(python3 -V 2>&1)" =~ ^(Python 3.4.*) ]]; then
#     sudo wget https://bootstrap.pypa.io/pip/3.4/get-pip.py -O /tmp/get-pip.py
# else
#     sudo wget https://bootstrap.pypa.io/get-pip.py -O /tmp/get-pip.py
# fi
# sudo python3 /tmp/get-pip.py
# sudo /usr/local/bin/pip3 install botocore
# sudo yum update -y
# sudo yum install -y aws-cli jq

# aws s3  cp /etc/nginx/nginx.conf


# curl https://packages.microsoft.com/config/rhel/9/prod.repo | sudo tee /etc/yum.repos.d/mssql-release.repo
# sudo yum remove unixODBC-utf16 unixODBC-utf16-devel #to avoid conflicts
# sudo ACCEPT_EULA=Y yum install -y msodbcsql18
# # optional: for bcp and sqlcmd
# sudo ACCEPT_EULA=Y yum install -y mssql-tools18
# echo ‘export PATH=“$PATH:/opt/mssql-tools18/bin”’ >> ~/.bashrc
# source ~/.bashrc
# # optional: for unixODBC development headers
# sudo yum install -y unixODBC-devel
# /bin/bash -c “$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)”
# brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
# brew update
# HOMEBREW_ACCEPT_EULA=Y brew install msodbcsql18 mssql-tools18
