SET allow_experimental_geo_types = 1;
CREATE DATABASE IF NOT EXISTS analytics_01;
CREATE TABLE IF NOT EXISTS analytics_01.events
(
    utm_valid               UInt8,
    utm_source              String,
	utm_medium              String,
	utm_campaign_name       String,
	utm_id                  String,
	utm_term                String,
	utm_content             String,

    ua_browser_name          LowCardinality(String),
	ua_browser_version_major UInt32,
	ua_browser_version       String,
	ua_os_name               LowCardinality(String),
	ua_OS_version_major      UInt32,
	ua_os_version            String,
	ua_device_brand          LowCardinality(String),
	ua_device_family         LowCardinality(String),
	ua_device_model          LowCardinality(String),

    si_screen_orientation Enum(
                                'Unknown' = 0, 
                                'PortraitPrimary' = 1, 
                                'PortraitSecondary' = 2, 
                                'LandscapePrimary' = 3, 
                                'LandscapeSecondary' = 4
                                ),
	si_screen               LowCardinality(String),
	si_screen_width         UInt16,
	si_screen_height        UInt16,
	si_viewport             LowCardinality(String),
	si_viewport_width       UInt16,
	si_viewport_height      UInt16,
	si_resolution           LowCardinality(String),
	si_resoluton_width      UInt16,
	si_resoluton_height     UInt16,
	si_pixel_ratio          Float32,
	si_color_depth          UInt16,

    rd_name          String,
	rd_external_host String,
	rd_referrer_type Enum(
                            'SearchEngine' = 1, 
                            'Social' = 2, 
                            'MailProvider' = 3
                            ), 

    gi_ip                          IPv4,
	gi_ip_country                  LowCardinality(String),
	gi_ip_city                     LowCardinality(String),
	gi_ip_city_geo_id              UInt16,
	gi_ip_location_latitude        Float64,
	gi_ip_location_longitude       Float64,
    gi_ip_location                 Point,

	gi_ip_location_accuracy_radius UInt16,
	gi_ip_asnumber                 UInt16,
	gi_ip_asname                   LowCardinality(String),
	gi_client_latitude             Float64,
	gi_client_longitude            Float64,
    gi_client_location             Point,

	gi_client_accuracy_radius      Float32,

    ci_type Enum(
                    'Other' = 0, 
                    'Std' = 1, 
                    'Amp' = 2, 
                    'Img'= 3
                    ),
	ci_hash             FixedString(32),    
	ci_std_init_time    Datetime,
	ci_std_random       String,
	ci_std_daily_time   Datetime,

	r_type  Enum( 
                    'EventJS' = 0, 
                    'EventServiceWorker' = 1, 
                    'PageViewJS' = 10, 
                    'PageViewAMP' = 11, 
                    'PageViewImage' = 12, 
                    'PageAPI' = 13
                    ),
	r_time          Datetime,
	r_project_id    String,
	r_cursor        UInt32,
	r_title         String,
	r_entity_id     String,
	r_user          String,
	r_keywords      Array(String),
	r_canonical     String,
    CONSTRAINT boolean Check utm_valid <=1
)
ENGINE = ReplicatedMergeTree('/clickhouse/tables/tc_shard_01/events', 'replica_01')
ORDER BY (r_project_id, r_time, xxHash32(ci_hash))
PARTITION BY toYYYYMM(r_time)
SAMPLE BY (xxHash32(ci_hash));
-- TTL r_time + INTERVAL 1 MONTH TO VOLUME 'single-cold';