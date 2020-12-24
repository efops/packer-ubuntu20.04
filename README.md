## Packer config to build Vsphere virtual machines templates from Ubuntu 20.04 live-server ISO file as a source.

I have used `iso_path` variable on ubuntu-20.04.json. But Also I have added `iso_url` variable to variables.json. So If you dont have ready Ubuntu-20.04 live-server then you can basically change `iso_path` variable with `iso_url` in ubuntu-20.04.json.
You can find more detailed information on my website (https://efkan-isazade.com/packer-vsphere-ubuntu20.04).

## Run packer build:

```bash
packer build -on-error=ask -var-file variables.json ubuntu-20.04.json
```

## Running packer build with hcl template
```bash
packer build -on-error=ask ubuntu-20.04.pkr.hcl
```
