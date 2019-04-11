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
  Array[String[1]] $lename = [$facts['fqdn']],
  Optional[Boolean] $lecron = false,
) inherits ::vsftpd::params {
  package { $package_name: ensure => installed }
  file { $configfile:
    require => Package[$package_name],
    backup  => '.backup',
    content => template($template),
  }
  if $letsencryptcert == true {
    if $lemail { 
      class {'letsencrypt':
        email => $lemail,
        config => {
          server => 'https://acme-staging.api.letsencrypt.org/directory',
        },
      }
      letsencrypt::certonly { $facts['fqdn']:        
        domains              => $lename,
        manage_cron          => $lecron,
        cron_hour            => '0',
        cron_minute          => '30',
        cron_success_command => '/usr/sbin/service vsftpd restart',
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
