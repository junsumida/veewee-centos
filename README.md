veewee-centos
=============

## USAGE

```bash
vagrant package --base centos-64 --output centos-64.box
vagrant box add centos-64 centos.box
vagrant up
bundle exec knife solo cook centos

ssh centos
git clone git@your-rails-app
cd your-rails-app
bundle install
rails server
```
