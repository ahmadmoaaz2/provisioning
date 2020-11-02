Vagrant.configure("2") do |config|
    config.vm.box = "basebox_4640"
    config.ssh.username = "admin"
    config.ssh.private_key_path = "./setup/acit_admin_id_rsa"

    config.vm.synced_folder ".", "/vagrant", disabled: true

    config.vm.define "todoapp" do |todoapp|
        todoapp.vm.provider "virtualbox" do |vb|
            vb.name = "TODO_APP_4640"
            vb.memory = 2048
        end
        todoapp.vm.hostname = "todoapp.bcit.local"
        todoapp.vm.network "private_network", ip: "192.168.150.10"
        todoapp.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "192.168.150.12"
        todoapp.vm.provision "file", source: "setup/todoapp.service", destination: "/tmp/todoapp.service"
        todoapp.vm.provision "shell", inline: <<-SHELL
            curl -sL https://rpm.nodesource.com/setup_14.x | bash -
            dnf install -y nodejs git

            git clone "https://github.com/timoguic/ACIT4640-todo-app.git" /home/todoapp/app
            npm install --prefix /home/todoapp/app
            sed -i "s~localhost/CHANGEME~192.168.150.11/acit4640~g" home/todoapp/app/config/database.js
            chmod a+rx /home/todoapp

            mv /tmp/todoapp.service /etc/systemd/system/todoapp.service

            systemctl daemon-reload
            systemctl enable todoapp
            systemctl start todoapp
        SHELL
    end

    config.vm.define "tododb" do |tododb|
        tododb.vm.provider "virtualbox" do |vb|
            vb.name = "TODO_DB_4640"
            vb.memory = 2048
        end
        tododb.vm.hostname = "tododb.bcit.local"
        tododb.vm.network "private_network", ip: "192.168.150.11"
        tododb.vm.provision "file", source: "./setup/mongodb-org-4.4.repo", destination: "/tmp/mongodb-org-4.4.repo"
        tododb.vm.provision "file", source: "./setup/mongodb_ACIT4640.tgz", destination: "/tmp/mongodb_ACIT4640.tgz"
        tododb.vm.provision "shell", inline: <<-SHELL
            mv /tmp/mongodb-org-4.4.repo /etc/yum.repos.d/mongodb-org-4.4.repo
            dnf install -y mongodb-org tar

            export LANG=C

            mv /tmp/mongodb_ACIT4640.tgz /home/admin/mongodb_ACIT4640.tgz
            tar -C /home/admin -xzf /home/admin/mongodb_ACIT4640.tgz
            mongorestore -d acit4640 /home/admin/ACIT4640
        SHELL
    end

    config.vm.define "todoproxy" do |todoproxy|
        todoproxy.vm.provider "virtualbox" do |vb|
            vb.name = "TODO_PROXY_4640"
            vb.memory = 2048
        end
        todoproxy.vm.hostname = "todoproxy.bcit.local"
        todoproxy.vm.network "private_network", ip: "192.168.150.12"
        todoproxy.vm.network "forwarded_port", guest: 80, host: 8888
        todoproxy.vm.provision "file", source: "./setup/nginx.conf", destination: "/tmp/nginx.conf"
        todoproxy.vm.provision "shell", inline: <<-SHELL
            dnf install -y nginx
            mv /tmp/nginx.conf /etc/nginx/nginx.conf
            systemctl daemon-reload
            systemctl enable nginx
            systemctl start nginx
        SHELL
    end
end