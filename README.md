veewee-centos
=============

## USAGE

```bash
vagrant box add veewee veewee.box
vagrant package --base centos-64 --output centos-64.box
vagrant box add centos-64 centos.box
vagrant up
bundle exec knife solo cook centos
```
