#
# Cookbook Name:: devbase
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
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

git "/home/vagrant/.dotfiles" do
  user 'vagrant'
  group 'vagrant'
  repository "https://github.com/luckypool/dotfiles.git"
  reference "master"
  action :sync
end

%w{.vimrc .tmux.conf .zshrc .zshrc.custom .gitconfig}.each do |rcfile|
  from = "/home/vagrant/.dotfiles/" + rcfile
  target = "/home/vagrant/" + rcfile
  link target do
    to from
  end
end

%w{.vim .vim/swp .vim/backup}.each do |dir|
  directory "/home/vagrant/" + dir do
    owner 'vagrant'
    group 'vagrant'
    action :create
  end
end

%w{.vim .vim/bundle .vim/autoload}.each do |dir|
  directory "/home/vagrant/" + dir do
    owner 'vagrant'
    group 'vagrant'
    action :create
  end
end

remote_file "/home/vagrant/.vim/autoload/pathogen.vim" do
  source "https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim"
end

node["devbase"]["vimplugins"].each do |plugin|
  git "/home/vagrant/.vim/bundle/" + plugin.split('/')[1] do
    user  node["devbase"]["user"]
    group node["devbase"]["group"]
    repository "https://github.com/" + plugin
    reference "master"
    action :sync
  end
end

include_recipe "rbenv::default"
include_recipe "rbenv::ruby_build"
rbenv_ruby "2.1.0"

%w{bundler foreman}.each do |gem|
  rbenv_gem gem do
    ruby_version "2.1.0"
  end
end

