## Packer config to build Vsphere virtual machines templates from Ubuntu 20.04 live-server ISO file as a source.

I have used `iso_path` variable on ubuntu-20.04.json. But Also I have added `iso_url` variable to variables.json. So If you dont have ready Ubuntu-20.04 live-server then you can basically change `iso_path` variable with `iso_url` in ubuntu-20.04.json.
I will post detailed documentation about packer and this repo on my website (https://efkan-isazade.com) soon and will explain every single detail there.

## Run packer build:

```bash
packer build -on-error=ask -var-file variables.json ubuntu-20.04.json
```
