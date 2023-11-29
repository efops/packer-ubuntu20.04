## Packer config to build Vsphere virtual machines templates from Ubuntu 20.04 live-server ISO file as a source.

I have used `iso_path` variable on ubuntu-20.04.json. But Also I have added `iso_url` variable to variables.json. So If you dont have ready Ubuntu-20.04 live-server then you can basically change `iso_path` variable with `iso_url` in ubuntu-20.04.json.
You can find more detailed information on my website (https://efkan-isazade.com/p/automating-ubuntu-20.04-live-server-template-generation-with-packer-vsphere-iso-build./).

## Run packer build:

```bash
packer build -on-error=ask -var-file variables.json ubuntu-20.04.json
```

## Running packer build with hcl template
```bash
packer build -debug -on-error=ask -var-file variables.pkrvars.hcl -var-file vsphere.pkrvars.hcl ubuntu-20.04.pkr.hcl
```

## Support

If you like it, Click [<script type="text/javascript" src="https://cdnjs.buymeacoffee.com/1.0.0/button.prod.min.js" data-name="bmc-button" data-slug="efkanisazade" data-color="#FFDD00" data-emoji=""  data-font="Cookie" data-text="Buy me a coffee" data-outline-color="#000000" data-font-color="#000000" data-coffee-color="#ffffff" ></script>]

Thank you
