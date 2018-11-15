# vsftpd Module

## Overview

This module install and configure vsftpd ftp server.

## Usage

Default configuration:

```puppet
include vsftpd
```

Custom configuration:

```puppet
class { 'vsftpd':
    anonymous_enable         => 'NO',
    anon_mkdir_write_enable  => 'NO',
    anon_other_write_enable  => 'NO',
    local_enable             => 'YES',
    download_enable          => 'YES',
    write_enable             => 'YES',
    local_umask              => '022',
    dirmessage_enable        => 'YES',
    xferlog_enable           => 'YES',
    connect_from_port_20     => 'YES',
    xferlog_std_format       => 'YES',
    chroot_local_user        => 'YES',
    chroot_list_enable       => 'YES',
    file_open_mode           => '0666'
    ftp_data_port            => '20',
    listen                   => 'YES',
    listen_ipv6              => 'NO',
    listen_port              => '21',
    pam_service_name         => 'vsftpd',
    tcp_wrappers             => 'YES',
    allow_writeable_chroot   => 'YES',
    pasv_enable              => 'YES',
    pasv_min_port            => '1024',
    pasv_max_port            => '1048',
    pasv_address             => '127.0.0.1',


}
```
Advanced Configuration

```puppet
    anon_umask               => '077',
    anon_root                => '/var/ftp/anonymous',
    ftpd_banner              => 'My custom banner',
    banner_file              => '/etc/vsftpd/my_banner.txt',
    max_clients              => '0',
    max_per_ip               => '0',
    ftp_username             => 'ftp',
    guest_enable             => 'NO',
    guest_username           => 'ftp',
    anon_world_readable_only => 'NO',
    ascii_download_enable    => 'NO',
    ascii_upload_enable      => 'NO',
    chown_uploads            => 'YES',
    chown_username           => 'linux,
    chroot_list_file         => '/etc/vsftpd/my_chroot_list',
    secure_chroot_dir        => '/usr/share/empty',
    user_config_dir          => '/etc/vsftpd/user_config/',
    userlist_deny            => 'YES',
    userlist_enable          => 'YES',
    userlist_file            => '/etc/vsftpd/my_userlist',
    delete_failed_uploads    => 'NO',
    cmds_allowed             => 'PASV,RETR,QUIT',
    cmds_denied              => 'PASV,RETR,QUIT',
    deny_file                => '{*.mp3,*.mov,.private}',
    hide_file                => '{*.mp3,.hidden,hide*,h?}',
    syslog_enable            => 'NO',
    dual_log_enable          => 'NO',
    hide_ids                 => 'NO',
    use_localtime            => 'NO',
    local_max_rate           => '0',
```

SSL integration

```puppet
    rsa_cert_file           => '/etc/ssl/private/vsftpd.pem',
    rsa_private_key_file    => '/etc/ssl/private/vsftpd.pem',
    ssl_enable              => 'YES',
    allow_anon_ssl          => 'NO',
    force_local_data_ssl    => 'YES',
    force_local_logins_ssl  => 'YES',
    ssl_tlsv1               => 'YES',
    ssl_sslv2               => 'NO',
    ssl_sslv3               => 'NO',
    require_ssl_reuse       => 'NO',
    ssl_ciphers             => 'HIGH',
```
