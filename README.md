## Packer config to build Vsphere virtual machines templates from Ubuntu 20.04 live-server ISO file as a source.

I have used `iso_path` variable on ubuntu-20.04.json. But Also I have added `iso_url` variable to variables.json. So If you dont have ready Ubuntu-20.04 live-server then you can basically change `iso_path` variable with `iso_url` in ubuntu-20.04.json.
On boot command I used my own static server for serving `user-data` and `meta-data` files. If you wish you can keep and use it otherwise in this repo I have also added these files, so you can use them with your own server `http://{{ .HTTPIP }}:{{ .HTTPPort }}/`. 
I will post detailed documentation about packer and this repo on my website (https://efkan-isazade.com) soon and will explain every single detail there.

```json
{
  "builders": [
    {
      "CPUs": 2,
      "RAM": 2048,
      "RAM_reserve_all": true,
      "firmware": "bios",
      "boot_command": [
         "<esc><esc><esc>",
         "<enter><wait>",
         "/casper/vmlinuz ",
         "root=/dev/sr0 ",
         "initrd=/casper/initrd ",
         "autoinstall ",
         "ds=nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
         "<enter>"
      ],
      "boot_wait": "2s",
      "convert_to_template": "true",
      "create_snapshot": "false",
      "datacenter": "{{user `vcenter_datacenter`}}",
      "datastore": "{{user `vcenter_datastore`}}",
      "disk_controller_type": "pvscsi",
      "folder": "{{user `vcenter_folder`}}",
      "guest_os_type": "ubuntu64Guest",
      "host": "{{user `vcenter_host`}}",
      "http_directory": "{{user `http_directory`}}",
      "insecure_connection": "true",
      "iso_checksum": "{{user `iso_checksum_type`}}:{{user `iso_checksum`}}",
      "iso_paths": "{{user `iso_paths`}}",
      "name": "Ubuntu-20.04",
      "network_adapters": [
        {
          "network": "{{user `vcenter_network`}}",
          "network_card": "vmxnet3"
        }
      ],
      "notes": "Default SSH User: {{user `ssh_username`}}\nDefault SSH Pass: {{user `ssh_password`}}\nBuilt by Packer @ {{isotime \"2006-01-02 03:04\"}}.",
      "password": "{{user `vcenter_password`}}",
      "shutdown_command": "echo 'ubuntu'|sudo -S shutdown -P now",
      "ssh_password": "{{user `ssh_password`}}",
      "ssh_timeout": "20m",
      "ssh_handshake_attempts": "100000",
      "ssh_username": "{{user `ssh_username`}}",
      "storage": [
        {
          "disk_size": 20480,
          "disk_thin_provisioned": true
        }
      ],
      "type": "vsphere-iso",
      "username": "{{user `vcenter_username`}}",
      "vcenter_server": "{{user `vcenter_server`}}",
      "vm_name": "{{user `vm_name`}}"
    }
  ],
  "provisioners": [
    {
       "type": "shell",
       "execute_command": "echo 'ubuntu' | {{.Vars}} sudo -S -E bash '{{.Path}}'",
       "script": "scripts/setup_ubuntu2004.sh"
     }
   ]
}
```

## Run packer build:

```bash
packer build -on-error=ask -var-file variables.json ubuntu-20.04.json
```
