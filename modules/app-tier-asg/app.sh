#!/bin/bash
dnf install -y git mariadb105 nodejs

mysql -h "${endpoint}" -u "${db_username}" -p"${db_password}" <<'EOF'
CREATE DATABASE IF NOT EXISTS ${db_name};
USE ${db_name};

CREATE TABLE IF NOT EXISTS tasks (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  done BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
EOF


cd /opt/
git clone https://github.com/rizwancloud/application_nodejs.git
cd application_nodejs/
sed -i 's|admin|'"${db_username}"'|g'  .env
sed -i 's|your_password|'"${db_password}"'|g'  .env
sed -i 's|your-rds-endpoint.region.rds.amazonaws.com|'"${endpoint}"'|g'  .env
sed -i 's|appdb|'"${db_name}"'|g'  .env
sed -i 's|/opt/app|/opt/application_nodejs|g'  app.service
npm install       
mv app.service /etc/systemd/system/app.service
sudo chmod 644 /etc/systemd/system/app.service
sudo mkdir -p /var/log/app
sudo chown ec2-user:ec2-user /var/log/app
sudo chmod 755 /var/log/app
sudo touch /var/log/app/app.log
sudo chown ec2-user:ec2-user /var/log/app/app.log
sudo chmod 644 /var/log/app/app.log
sudo nginx -t
sudo systemctl reload nginx
sudo systemctl daemon-reload
sudo systemctl enable --now app
---------------------------------------------------------------------
# cloudwatch log setup
---------------------------------------------------------------------
dnf install -y amazon-cloudwatch-agent
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
cat > /opt/aws/amazon-cloudwatch-agent/etc/config.json <<'EOF'
{
  "agent": { "run_as_user": "root" },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/app/app.log",
            "log_group_name": "/3tawt/app-tier",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
EOF

/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 -s \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json