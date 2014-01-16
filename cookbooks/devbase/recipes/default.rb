#
# Cookbook Name:: devbase
# Recipe:: default
#

%w{curl vim zsh}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/vagrant/.oh-my-zsh" do
  user 'vagrant'
  group 'vagrant'
  repository "https://github.com/robbyrussell/oh-my-zsh.git"
  reference "master"
  action :sync
end

execute "change shell" do
  command "chsh -s $(which zsh) vagrant"
  not_if "echo $0 | grep zsh"
end

service 'iptables' do
  action [:disable, :stop]
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby "2.1.0"

%w{bundler foreman}.each do |gem|
  rbenv_gem gem do
    ruby_version "2.1.0"
  end
end

execute "yum update" do
  command "yum -y update"
end
