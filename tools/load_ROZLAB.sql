
/* t_bios_asset_element_type */
select @asset_element_group := id_asset_element_type from t_bios_asset_element_type where name ='group';
select @asset_element_datacenter := id_asset_element_type from t_bios_asset_element_type where name ='datacenter';
select @asset_element_room := id_asset_element_type from t_bios_asset_element_type where name ='room';
select @asset_element_row := id_asset_element_type from t_bios_asset_element_type where name ='row';
select @asset_element_rack := id_asset_element_type from t_bios_asset_element_type where name ='rack';
select @asset_element_device := id_asset_element_type from t_bios_asset_element_type where name ='device';

/* t_bios_asset_device_type */
select @asset_device_ups := id_asset_device_type from t_bios_asset_device_type where name = 'ups'; 
select @asset_device_epdu := id_asset_device_type from t_bios_asset_device_type where name = 'epdu';
select @asset_device_server := id_asset_device_type from t_bios_asset_device_type where name = 'server';
select @asset_device_main := id_asset_device_type from t_bios_asset_device_type where name = 'main';

/* t_bios_asset_link_type; */
select @asset_link_powerchain := id_asset_link_type from t_bios_asset_link_type where name = 'power chain';

/* t_bios_device_type */
select @device_unclassified := id_device_type from t_bios_device_type where name = 'not_classified';
select @device_ups := id_device_type from t_bios_device_type where name = 'ups';
select @device_epdu := id_device_type from t_bios_device_type where name = 'epdu';
select @device_pdu := id_device_type from t_bios_device_type where name = 'pdu';
select @device_server := id_device_type from t_bios_device_type where name = 'server';

/* ************* */
/* ROZ Rack data */
/* ************* */

/* ROZ-LAB */
insert into t_bios_asset_element (name , id_type, id_parent,status,priority,business_crit) values ("DC-ROZ", @asset_element_datacenter,  NULL,"active",1,1);
select @last_asset_element:=id_asset_element from t_bios_asset_element where name="DC-ROZ";
set @last_datacenter := @last_asset_element; 
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description",    "EEIC Roztoky DC", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("company",    "EATON", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("site",       "EEIC", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("country",    "Czech Republic", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("address",    "Bořivojova 2380, Roztoky", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Michal Hrušecký", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "michalhrusecky@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "240211151532", @last_asset_element);
/* ROZ.ROOM01 */
insert into t_bios_asset_element (id_asset_element, name , id_type, id_parent,status,priority,business_crit) values (NULL, "ROZ.ROOM01", @asset_element_room, @last_datacenter,"active",1,1);
set @last_asset_element := LAST_INSERT_ID();
set @last_room := @last_asset_element;
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "IT Server room", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("floor", "0", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Michal Hrušecký", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "michalhrusecky@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "240211151532", @last_asset_element);

/* ROZ.ROOM01.RACK01 */
insert into t_bios_asset_element (id_asset_element, name , id_type, id_parent,status,priority,business_crit) values (NULL, "ROZ.ROOM01.RACK01", @asset_element_rack, @last_room,"active",1,1);
set @last_asset_element := LAST_INSERT_ID();
set @last_rack := @last_asset_element;
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "RESSPU4210KB 600mm x 1000mm - 42U Rack", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("free_space", "27",      @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "Cooper",   @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",      "27U",     @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("asset_tag",       "EATON123456",     @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("serial_no",       "21545212HGFV2",     @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Michal Hrušecký", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "michalhrusecky@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "240211151532", @last_asset_element);

/* ROZ.UPS1 */
insert into t_bios_asset_element (name , id_type, id_parent,status,priority,business_crit) values ("ROZ.UPS1", @asset_element_device, @last_rack,"active",1,1);
set @last_asset_element := LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "UPS1 9PX 6kVA", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "9PX 5kVA", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("installation_date", "2014-11-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("end_warranty_date", "2018-31-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("warranty_expiration_date", "2020-31-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("battery_installation_date", "2014-11-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("battery_warranty_expiration_date", "2019-11-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("battery_maintenance_date", "2016-11-12", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "3",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "0",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "EATON", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("hostname.1", "nmc03", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("full_hostname", "nmc03.roz.lab.etn", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Michal Hrušecký", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "michalhrusecky@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "240211151532", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_ups);


/* ROZ.ePDU10 */
insert into t_bios_asset_element (name , id_type, id_parent,status,priority,business_crit) values ("ROZ.ePDU10", @asset_element_device, @last_rack,"active",1,1);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "ePDU10 eMAA10", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "Eaton ePDU MA 1P IN:IEC309 16A OUT:21xC13, 3xC19", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "EATON", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("hostname", "epdu10", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("full_hostname", "epdu10.roz.lab.etn.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Michal Hrušecký", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "michalhrusecky@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "240211151532", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_epdu);

/* ROZ.ePDU04 */
insert into t_bios_asset_element (name , id_type, id_parent,status,priority,business_crit) values ("ROZ.ePDU04", @asset_element_device, @last_rack,"active",1,1);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "ePDU04 eMAA10", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "Eaton ePDU MA 1P IN:IEC309 16A OUT:21xC13, 3xC19", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "EATON", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("hostname", "epdu04", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("full_hostname", "epdu04.roz.lab.etn.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Jean-Luc Picard", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "captain@ssenterprise.mil", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "555-4242", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_epdu);

/* GRASSHOPPER */
insert into t_bios_asset_element (name , id_type, id_parent,status,priority,business_crit) values ("GRASSHOPPER",  @asset_element_device, @last_rack,"active",1,1);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description",        "Secondary BIOS server (kvm)",  @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "1",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "24",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "Dell", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "PowerEdge R320", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Tintin", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "tintin+srv1-lab@tinint.net", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+32-2-555-42-42", @last_asset_element);
insert into t_bios_asset_device  (id_asset_device, id_asset_element, id_asset_device_type) values (NULL, @last_asset_element, @asset_device_server);

/* SRV13 */
insert into t_bios_asset_element (name , id_type, id_parent) values ("SRV13", @asset_element_device, @last_rack);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description","IT Power testing server", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "1",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "25",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "HP", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "HP DL360p G8", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Athos", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "athos@mousquetaires.defense.gouv.fr", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+33 (0)4 42 42 42 42", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_server);

/* HORNET */
insert into t_bios_asset_element (name , id_type, id_parent) values ("HORNET",  @asset_element_device, @last_rack);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description",        "Main BIOS server (kvm, OBS, CI)",  @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "1",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "27",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "HP", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "HP DL360p G8", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Porthos", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "porthos@mousquetaires.defense.gouv.fr", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+33 (0)4 42 42 42 42", @last_asset_element);
insert into t_bios_asset_device  (id_asset_device, id_asset_element, id_asset_device_type) values (NULL, @last_asset_element, @asset_device_server);

/* SHERPA */
insert into t_bios_asset_element (name , id_type, id_parent) values ("SHERPA", @asset_element_device, @last_rack);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description","BIOS NAS", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "1",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "26",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "Synology", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "RackStation RS815RP+", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Aramis", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "aramis@mousquetaires.defense.gouv.fr", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+33 (0)4 42 42 42 42", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_server);

/* HP-UX */
insert into t_bios_asset_element (name , id_type, id_parent) values ("HP-UX", @asset_element_device, @last_rack);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description","Testing machine with HP-UX", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "2",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "22",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "HP", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "Integrity rx2088 i2", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Evgeny Klimov", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "evgenyklimov@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+420 221 151 535", @last_asset_element);
insert into t_bios_asset_device  (id_asset_element, id_asset_device_type) values (@last_asset_element, @asset_device_server);

/* BIOS-RC-DEMO */
insert into t_bios_asset_element (name , id_type, id_parent) values ("BIOS-RC-DEMO",  @asset_element_device, @last_rack);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description",        "BIOS Rack Controller",  @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("u_size",  "1",        @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("location_u_pos",     "37",       @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("manufacturer", "EATON", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("model", "RC3", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_name",    "Gerald Guillaume", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_email",    "geraldguillaume@eaton.com", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("contact_phone",    "+33 (0)4 42 42 42 42", @last_asset_element);
insert into t_bios_asset_device  (id_asset_device, id_asset_element, id_asset_device_type) values (NULL, @last_asset_element, @asset_device_server);

/* ROZ.MAIN */
insert into t_bios_asset_element (name , id_type, id_parent) values ("ROZ.MAIN", @asset_element_device, @last_datacenter);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "MAIN 240V", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("phase",       "1",         @last_asset_element);
insert into t_bios_asset_device  (id_asset_device, id_asset_element, id_asset_device_type) values (NULL, @last_asset_element, @asset_device_main);

/* ROZ.GROUP.MAIN */
insert into t_bios_asset_element (name , id_type, id_parent) values ("ROZ.GROUP.MAIN", @asset_element_group, @last_datacenter);
set @last_asset_element = LAST_INSERT_ID();
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("description", "input power chain", @last_asset_element);
insert into t_bios_asset_ext_attributes (keytag, value, id_asset_element) values ("type",        "input_power",       @last_asset_element);

/* Create a group */
insert into t_bios_asset_group_relation
    (id_asset_group, id_asset_element)
values
(
    (select id_asset_element from `t_bios_asset_element` where name = 'ROZ.GROUP.MAIN'),
    (select id_asset_element from `t_bios_asset_element` where name = 'ROZ.MAIN')
);

/* Asset links */

/* link (ROZ.MAIN, ROZ.UPS1, 'power chain') */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.MAIN'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.UPS1'),
    @asset_link_powerchain
);

/* link (ROZ.UPS1, ROZ.ePDU10, 'power chain') */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.UPS1'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    @asset_link_powerchain
);

/* link (ROZ.UPS1, ROZ.ePDU04, 'power chain') */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.UPS1'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    @asset_link_powerchain
);

/* link (ROZ.ePDU10, HP-UX, 'power chain', A4, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'HP-UX'),
    @asset_link_powerchain,
    "3", 
    "1"
);
/* link (ROZ.ePDU04, HP-UX, 'power chain', A4, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'HP-UX'),
    @asset_link_powerchain,
    "3",
    "2"
);

/* link (ROZ.ePDU10,GRASSHOPPER, 'power chain', A4, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'GRASSHOPPER'),
    @asset_link_powerchain,
    "4", 
    "1"
);
/* link (ROZ.ePDU04, GRASSHOPPER, 'power chain', A4, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'GRASSHOPPER'),
    @asset_link_powerchain,
    "4",
    "2"
);
/* link (ROZ.ePDU10, SRV13, 'power chain', A5, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'SRV13'),
    @asset_link_powerchain,
    "5",
    "1"
);
/* link (ROZ.ePDU04, SRV13, 'power chain', A5, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'SRV13'),
    @asset_link_powerchain,
    "5",
    "2"
);

/* link (ROZ.ePDU10, HORNET, 'power chain', A6, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'HORNET'),
    @asset_link_powerchain,
    "6",
    "1"
);
/* link (ROZ.ePDU04, HORNET, 'power chain', A6, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'HORNET'),
    @asset_link_powerchain,
    "6",
    "2"
);

/* link (ROZ.ePDU10, SHERPA, 'power chain', A7, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'SHERPA'),
    @asset_link_powerchain,
    "7",
    "1"
);
/* link (ROZ.ePDU04, SHERPA, 'power chain', A7, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'SHERPA'),
    @asset_link_powerchain,
    "7",
    "2"
);

/* link (ROZ.ePDU10, BIOS-RC-DEMO, 'power chain', A8, 1) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU10'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'BIOS-RC-DEMO'),
    @asset_link_powerchain,
    "8",
    "1"
);
/* link (ROZ.ePDU04, BIOS-RC-DEMO, 'power chain', A8, 2) */
insert into t_bios_asset_link
    (id_asset_device_src, id_asset_device_dest, id_asset_link_type, src_out, dest_in)
values 
(
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'ROZ.ePDU04'),
    (select id_asset_device from t_bios_asset_device as t1 INNER JOIN t_bios_asset_element as t2 ON t1.id_asset_element = t2.id_asset_element where name = 'BIOS-RC-DEMO'),
    @asset_link_powerchain,
    "8",
    "2"
);


/* A manual propagate an asset part to monitor part*/
/* UPSs */
INSERT INTO t_bios_discovered_device (name,id_device_type) VALUES ('ROZ.UPS1', @device_ups);
INSERT INTO t_bios_monitor_asset_relation (id_discovered_device,id_asset_element) VALUES (
    (SELECT id_discovered_device FROM t_bios_discovered_device WHERE name = 'ROZ.UPS1'),
    (SELECT id_asset_element FROM t_bios_asset_element WHERE name = 'ROZ.UPS1')
);


/* ePDUs */
INSERT INTO t_bios_discovered_device (name,id_device_type) VALUES ('ROZ.ePDU10', @device_epdu);
INSERT INTO t_bios_discovered_device (name,id_device_type) VALUES ('ROZ.ePDU04', @device_epdu);
INSERT INTO t_bios_monitor_asset_relation (id_discovered_device,id_asset_element) VALUES (
    (SELECT id_discovered_device FROM t_bios_discovered_device WHERE name = 'ROZ.ePDU10'),
    (SELECT id_asset_element FROM t_bios_asset_element WHERE name = 'ROZ.ePDU10')
);
INSERT INTO t_bios_monitor_asset_relation (id_discovered_device,id_asset_element) VALUES (
    (SELECT id_discovered_device FROM t_bios_discovered_device WHERE name = 'ROZ.ePDU04'),
    (SELECT id_asset_element FROM t_bios_asset_element WHERE name = 'ROZ.ePDU04')
);

