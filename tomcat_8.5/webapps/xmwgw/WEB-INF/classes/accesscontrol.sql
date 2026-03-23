CREATE TABLE `xmwacl` (
  `aclrefid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aclclientid` varchar(64) NOT NULL,
  `aclclientdetail` varchar(256) NOT NULL,
  `acliplist` varchar(4096) NOT NULL,
  `aclfield1` varchar(64) DEFAULT NULL,
  `aclfield2` varchar(128) DEFAULT NULL,
  `isactive` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `createddate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `modifieddate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`aclrefid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='access control list for client';