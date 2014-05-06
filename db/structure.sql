CREATE TABLE `installed_measure_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `installed_measures` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer_unique_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tenant_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `street_address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zipcode` int(11) DEFAULT NULL,
  `plus_four` int(11) DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `finish_date` date DEFAULT NULL,
  `consent_date` date DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_properties_on_customer_unique_id` (`customer_unique_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4087 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `property_measures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property_id` int(11) DEFAULT NULL,
  `measure_id` int(11) DEFAULT NULL,
  `comment` text COLLATE utf8_unicode_ci,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_property_measures_on_property_id` (`property_id`),
  KEY `index_property_measures_on_measure_id` (`measure_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `record_lookups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `property_id` int(11) DEFAULT NULL,
  `utility_type_id` int(11) DEFAULT NULL,
  `company_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `acct_num` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_record_lookups_on_property_id` (`property_id`),
  KEY `index_record_lookups_on_utility_type_id` (`utility_type_id`),
  KEY `index_record_lookups_on_acct_num` (`acct_num`)
) ENGINE=InnoDB AUTO_INCREMENT=2040 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `recordings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acctnum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read_date` date DEFAULT NULL,
  `consumption` float DEFAULT NULL,
  `days_in_month` int(11) DEFAULT NULL,
  `utility_type_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_recordings_on_utility_type_id` (`utility_type_id`),
  KEY `index_recordings_on_acctnum` (`acctnum`)
) ENGINE=InnoDB AUTO_INCREMENT=24604 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `stagings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `acctnum` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `read_date` date DEFAULT NULL,
  `consumption` float DEFAULT NULL,
  `days_in_month` int(11) DEFAULT NULL,
  `utility_type_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_recordings_on_utility_type_id` (`utility_type_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `test` (
  `owner_name` varchar(25) DEFAULT NULL,
  `unique_id` varchar(8) DEFAULT NULL,
  `company` varchar(25) DEFAULT NULL,
  `account_number` varchar(25) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `uploads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `upload_date` datetime DEFAULT NULL,
  `process_date` datetime DEFAULT NULL,
  `uploaded_by` varchar(255) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reset_password_sent_at` datetime DEFAULT NULL,
  `remember_created_at` datetime DEFAULT NULL,
  `sign_in_count` int(11) DEFAULT '0',
  `current_sign_in_at` datetime DEFAULT NULL,
  `last_sign_in_at` datetime DEFAULT NULL,
  `current_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_sign_in_ip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE `utility_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `units` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO schema_migrations (version) VALUES ('20131007165656');

INSERT INTO schema_migrations (version) VALUES ('20131028173244');

INSERT INTO schema_migrations (version) VALUES ('20131104163104');

INSERT INTO schema_migrations (version) VALUES ('20131105031613');

INSERT INTO schema_migrations (version) VALUES ('20131118170442');

INSERT INTO schema_migrations (version) VALUES ('20131123040943');

INSERT INTO schema_migrations (version) VALUES ('20131123050048');

INSERT INTO schema_migrations (version) VALUES ('20131123062301');

INSERT INTO schema_migrations (version) VALUES ('20131123200254');

INSERT INTO schema_migrations (version) VALUES ('20131130183903');

INSERT INTO schema_migrations (version) VALUES ('20131212224800');

INSERT INTO schema_migrations (version) VALUES ('20140303041754');

INSERT INTO schema_migrations (version) VALUES ('20140324051115');

INSERT INTO schema_migrations (version) VALUES ('20140324051351');

INSERT INTO schema_migrations (version) VALUES ('20140324052707');

INSERT INTO schema_migrations (version) VALUES ('20140324162653');

INSERT INTO schema_migrations (version) VALUES ('20140324162718');

INSERT INTO schema_migrations (version) VALUES ('20140324162857');

INSERT INTO schema_migrations (version) VALUES ('20140324171505');

INSERT INTO schema_migrations (version) VALUES ('20140324181351');

INSERT INTO schema_migrations (version) VALUES ('20140325061447');

INSERT INTO schema_migrations (version) VALUES ('20140325072919');

INSERT INTO schema_migrations (version) VALUES ('20140325073343');

INSERT INTO schema_migrations (version) VALUES ('20140325073359');

INSERT INTO schema_migrations (version) VALUES ('20140325073434');

INSERT INTO schema_migrations (version) VALUES ('20140325073458');