CREATE TABLE  "ESP_SPORTHALLEN" 
   (	"HALLEN_NR" NUMBER NOT NULL ENABLE, 
	"HALLEN_NAME" VARCHAR2(150) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"HALLEN_NAME_KURZ" VARCHAR2(10) COLLATE "USING_NLS_COMP", 
	"CSS_CLASS" VARCHAR2(35) COLLATE "USING_NLS_COMP", 
	 CONSTRAINT "ESP_SPORTHALLEN_PK" PRIMARY KEY ("HALLEN_NR")
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"
/
CREATE TABLE  "ESP_SPIELPLAN" 
   (	"BEGEGNUNG_NR" NUMBER NOT NULL ENABLE, 
	"TERMIN_ZEIT" TIMESTAMP (6) WITH TIME ZONE NOT NULL ENABLE, 
	"DAUER" NUMBER NOT NULL ENABLE, 
	"SAISON" VARCHAR2(20) COLLATE "USING_NLS_COMP", 
	"ALTERSKLASSE" VARCHAR2(50) COLLATE "USING_NLS_COMP", 
	"LIGA" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"STAFFEL" VARCHAR2(100) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"SPIELTAG" NUMBER, 
	"HEIM_VEREIN_NR" NUMBER, 
	"HEIM_VEREIN_NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"GAST_VEREIN_NR" NUMBER, 
	"GAST_VEREIN_NAME" VARCHAR2(50) COLLATE "USING_NLS_COMP" NOT NULL ENABLE, 
	"TORE_HEIM" NUMBER, 
	"TORE_GAST" NUMBER, 
	"HALLEN_NR" NUMBER NOT NULL ENABLE, 
	"AKTIV" NUMBER(1,0) NOT NULL ENABLE, 
	 CONSTRAINT "ESP_SPIELPLAN_PK" PRIMARY KEY ("BEGEGNUNG_NR")
  USING INDEX  ENABLE
   )  DEFAULT COLLATION "USING_NLS_COMP"
/
CREATE TABLE  "ESP_EINSATZPLAN" 
   (	"BEGEGNUNG_NR" NUMBER NOT NULL ENABLE, 
	"AUFBAU" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"ABBAU" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"KAMPFRICHTER_1" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"KAMPFRICHTER_2" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"SCHIEDSRICHTER" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"ORDNER_1" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"ORDNER_2" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"WISCHER" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"VERKÄUFER_1" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"VERKÄUFER_2" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"EINLASS_KONTROLLE_1" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"EINLASS_KONTROLLE_2" VARCHAR2(255) COLLATE "USING_NLS_COMP", 
	"MITTEILUNG" VARCHAR2(4096) COLLATE "USING_NLS_COMP"
   )  DEFAULT COLLATION "USING_NLS_COMP"
/

ALTER TABLE  "ESP_SPIELPLAN" ADD CONSTRAINT "ESP_SPIELPLAN_FK1" FOREIGN KEY ("HALLEN_NR")
	  REFERENCES  "ESP_SPORTHALLEN" ("HALLEN_NR") ENABLE
/
ALTER TABLE  "ESP_EINSATZPLAN" ADD CONSTRAINT "ESP_EINSATZPLAN_FK1" FOREIGN KEY ("BEGEGNUNG_NR")
	  REFERENCES  "ESP_SPIELPLAN" ("BEGEGNUNG_NR") ENABLE
/

CREATE UNIQUE INDEX  "ESP_SPORTHALLEN_PK" ON  "ESP_SPORTHALLEN" ("HALLEN_NR")
/
CREATE UNIQUE INDEX  "ESP_SPIELPLAN_PK" ON  "ESP_SPIELPLAN" ("BEGEGNUNG_NR")
/
CREATE UNIQUE INDEX  "SYS_IL0000086581C00014$$" ON  "ESP_EINSATZPLAN" (
/

CREATE OR REPLACE EDITIONABLE PACKAGE  "ESP_SPIELPLAN_API" as

procedure merge_begegnung (
   p_begegnung_nr in number,
   p_termin_zeit in timestamp with time zone, 
   p_dauer in number default 2,
   p_saison in varchar2 default '2021/22',
   p_altersklasse in varchar2 default 'Männer',
   p_liga in varchar2 default 'Bezirksklasse',
   p_staffel in varchar2 default '',
   p_spieltag in number default 1,
   p_hallen_nr in number default 210463,
   p_heim_verein_nr in number default 0,
   p_heim_verein_name in varchar2,
   p_gast_verein_nr in number default 0,
   p_gast_verein_name in varchar2,
   p_tore_heim in number default 0,
   p_tore_gast in number default 0,
   p_aktiv in number default 1
   );

end;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY  "ESP_SPIELPLAN_API" as

procedure merge_begegnung (
   p_begegnung_nr in number,
   p_termin_zeit in timestamp with time zone, 
   p_dauer in number default 2,
   p_saison in varchar2 default '2021/22',
   p_altersklasse in varchar2 default 'Männer',
   p_liga in varchar2 default 'Bezirksklasse',
   p_staffel in varchar2 default '',
   p_spieltag in number default 1,
   p_hallen_nr in number default 210463,
   p_heim_verein_nr in number default 0,
   p_heim_verein_name in varchar2,
   p_gast_verein_nr in number default 0,
   p_gast_verein_name in varchar2,
   p_tore_heim in number default 0,
   p_tore_gast in number default 0,
   p_aktiv in number default 1
   )

   is
      l_dauer number;
   begin
      if (p_dauer <= 0)
         then 
            l_dauer := 2;
         else
            l_dauer := p_dauer;
      end if;
      

      insert into esp_spielplan values(
               p_begegnung_nr,
               p_termin_zeit,
               l_dauer,
               p_saison,
               p_altersklasse,
               p_liga,
               p_staffel,
               p_spieltag,
               p_heim_verein_nr,
               p_heim_verein_name,
               p_gast_verein_nr,
               p_gast_verein_name,
               p_tore_heim,
               p_tore_gast,
               p_hallen_nr,
               p_aktiv
             );

	    insert into esp_einsatzplan (begegnung_nr) values (p_begegnung_nr);
		
    exception
      when dup_val_on_index 
         then
           update esp_spielplan
                set termin_zeit = p_termin_zeit,
                    dauer = l_dauer,
                    saison = p_saison,
                    altersklasse = p_altersklasse,
                    liga = p_liga,
                    staffel = p_staffel,
                    hallen_nr = p_hallen_nr,
                    heim_verein_nr = p_heim_verein_nr,
					heim_verein_name = p_heim_verein_name,
                    gast_verein_nr = p_gast_verein_nr,
					gast_verein_name = p_gast_verein_name,
                    tore_heim = p_tore_heim,
                    tore_gast = p_tore_gast,
                    aktiv = p_aktiv
                where begegnung_nr = p_begegnung_nr; 
    end merge_begegnung;

end;
/
