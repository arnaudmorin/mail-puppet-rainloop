#
# Mailops Team
#
# Install rainloop web client
#

class rainloop {
  # Includes
  include '::base::nginx'

  # Packages
  package { 'php7.0-fpm':     ensure => latest }
  package { 'php7.0-mysql':   ensure => latest }
  package { 'php7.0-mcrypt':  ensure => latest }
  package { 'php7.0-cli':     ensure => latest }
  package { 'php7.0-curl':    ensure => latest }
  package { 'php7.0-sqlite3': ensure => latest }
  package { 'php7.0-xml':     ensure => latest }

  ## Rainloop files
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
    cwd     => '/var/www/rainloop/public_html/',
    creates => '/var/www/rainloop/public_html/index.php',
    require => [
      Package['php7.0-fpm'],
      Package['php7.0-mysql'],
      Package['php7.0-mcrypt'],
      Package['php7.0-cli'],
      Package['php7.0-curl'],
      Package['php7.0-sqlite3'],
      Package['php7.0-xml'],
      File['/var/www/rainloop/public_html/']],
  }

  # Nginx config
  file { '/etc/nginx/sites-available/rainloop':
    ensure  => file,
    content => template("${module_name}/rainloop"),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/rainloop':
    ensure  => link,
    target  => '/etc/nginx/sites-available/rainloop',
    notify  => Service['nginx'],
  }
}
