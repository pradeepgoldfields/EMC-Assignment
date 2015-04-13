class tomcat6 (
  $tomcat_user = '',
  $java_opts = '-Djava.awt.headless=true -Xmx128m -XX:+UseConcMarkSweepGC',
  $lang = 'en_US') {

  include tomcat6::params

  if $tomcat_user == '' {
    $tomcat_user_internal = $tomcat6::params::tomcat_user
  } else {
    $tomcat_user_internal = $tomcat_user
  }

  if $::osfamily == 'RedHat' {
    require epel
  }
 package {'java-1.7.0-openjdk' :
    ensure => installed,
  } ->
  
  package {'tomcat6' :
    ensure => installed,
  } ->
  file {$tomcat6::params::tomcat_settings :
    ensure  => present,
    content => template('tomcat6/tomcat6.erb'),
  } ->
  
  file{ '/var/lib/tomcat6/webapps/petclinic.war' :
   ensure  => present,
    source => '/vagrant/modules/target/petclinic.war',
  }->
  
  service {'tomcat6' :
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
  }

}
