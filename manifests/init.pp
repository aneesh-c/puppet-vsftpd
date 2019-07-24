# == Class: vsftpd
#
# === Examples
#
#  class { vsftpd:
#    pam_service_name        => 'ftp',
#    pasv_enable             => 'YES',
#    pasv_min_port           => '1024',
#    pasv_max_port           => '1048',
#    pasv_address            => '127.0.0.1',
#  }
#
# === Authors
#
# Aneesh C <aneeshchandrasekharan@gmail.com>
#

class vsftpd (
  $package_name            = [ 'vsftpd' ],
  $configfile              = $::vsftpd::params::configfile,
  $template                = 'vsftpd/configfile.erb',
  $anonymous_enable        = undef,
  $local_enable            = undef,
  $write_enable            = undef,
  $local_umask             = undef,
  $dirmessage_enable       = undef,
  $xferlog_enable          = undef,
  $connect_from_port_20    = undef,
  $xferlog_std_format      = undef,
  $chroot_local_user       = undef,
  $listen                  = undef,
  $listen_ipv6             = undef,
  $pam_service_name        = undef,
  $userlist_enable         = undef,
  $tcp_wrappers            = undef,
  $use_localtime           = undef,
  $secure_chroot_dir       = undef,
  $rsa_cert_file           = undef,
  $rsa_private_key_file    = undef,
  $ssl_enable              = undef,
  $allow_writeable_chroot  = undef,
  $pasv_enable             = undef,
  $pasv_min_port           = undef,
  $pasv_max_port           = undef,
  $pasv_address            = undef,
  $allow_anon_ssl          = undef,
  $force_local_data_ssl    = undef,
  $force_local_logins_ssl  = undef,
  $ssl_tlsv1               = undef,
  $ssl_sslv2               = undef,
  $ssl_sslv3               = undef,
  $require_ssl_reuse       = undef,
  $ssl_ciphers             = undef,
  $async_abor_enable       = undef,
  $data_connection_timeout = undef,
  $debug_ssl               = undef,
  $force_dot_files         = undef,
  $idle_session_timeout    = undef,
  $passwd_chroot_enable    = undef,
  $session_support         = undef,
  $xferlog_file            = undef,
  $manage_service          = true,
  Boolean $letsencryptcert = false,
  Optional[String] $lemail = undef,
  Boolean $leprod          = false,
  Array[String[1]] $lename = [$facts['fqdn']],
  Optional[Boolean] $lecron = false,
  Optional[String] $leconf = '/etc/letsencrypt',
  Optional[String] $lecron_before = undef,
  Optional[String] $lecron_success = undef
) inherits ::vsftpd::params {
  package { $package_name: ensure => installed }
  file { $configfile:
    require => Package[$package_name],
    backup  => '.backup',
    content => template($template),
  }
  if $letsencryptcert == true {
    if $lemail { 
      if $leprod {
        $leserver = 'https://acme-v02.api.letsencrypt.org/directory'
      } else {
        $leserver = 'https://acme-staging.api.letsencrypt.org/directory'
      }
      class {'letsencrypt':
        email       => $lemail,
        config_dir  => $leconf,
        config_file => "${leconf}/cli.ini",
        config      => {
          server => $leserver,
        },
      }
      letsencrypt::certonly { pick($lename):
        domains              => $lename,
        manage_cron          => $lecron,
        config_dir           => $leconf,
        additional_args      => ["--config-dir ${leconf}"],
        cron_hour            => '0',
        cron_minute          => '30',
        cron_before_command  => $lecron_before,
        cron_success_command => $lecron_success,
        suppress_cron_output => true,
      }
    }
  }
  if $manage_service {
    case $facts['osfamily'] {
      'RedHat': {
         service { 'vsftpd':
           require => Package[$package_name],
           enable  => true,
         }
      }
      'Debian': {
         if $facts['operatingsystemmajrelease'] > 8 {
            service { 'vsftpd':
              require => Package[$package_name],
              enable  => true,
            }
         }
      }
    }
  }
}
