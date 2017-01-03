#
# Mailops Team
#
# Install rainloop web client
#

class rainloop {
  # Packages
  package { 'nginx':       ensure => latest }
  package { 'php5-fpm':    ensure => latest }
  package { 'php5-mysql':  ensure => latest }
  package { 'php5-mcrypt': ensure => latest }
  package { 'php5-cli':    ensure => latest }
  package { 'php5-curl':   ensure => latest }
  package { 'php5-sqlite': ensure => latest }

  # Rainloop files
  file { '/var/www/':
    ensure  => directory,
  }

  file { '/var/www/rainloop':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
  }

  file { '/var/www/rainloop/public_html/':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
    recurse => true,
  }

  file { '/var/www/rainloop/logs/':
    ensure  => directory,
    owner   => 'www-data',
    group   => 'www-data',
  }

  exec { 'install-rainloop':
    command => '/usr/bin/curl -s http://repository.rainloop.net/installer.php | php',
    creates => '/var/www/rainloop/public_html/index.php',
    require => [Package['php5-cli'], File['/var/www/rainloop/public_html/']],
  }

  # Nginx config
  file { '/etc/nginx/sites-available/rainloop':
    ensure  => file,
    source  => "puppet:///modules/${module_name}/rainloop",
    require => Package['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/rainloop':
    ensure  => link,
    target  => '/etc/nginx/sites-available/rainloop',
  }
}
