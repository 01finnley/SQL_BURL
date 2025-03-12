/* Pro Kunde und Pro Fahrzeug die Anzahl der Ausleih */
SELECT K.id_kunde, F.id_fahrzeug, COUNT(FB.id_fahrzeugbuchung) AS anzahl
FROM tbl_kunde AS K, tbl_fahrzeugbuchung AS FB, tbl_fahrzeug AS F
WHERE K.id_kunde = FB.kunde_id
AND FB.fahrzeug_id = F.id_fahrzeug
GROUP BY K.id_kunde, F.id_fahrzeug
HAVING anzahl = 3;





  SELECT YEAR(FB.buchungsdatum) AS jahr, 
         MONTH(FB.buchungsdatum) AS monat, 
         COUNT(*) AS anzahl_buchungen
    FROM tbl_flugbuchung AS FB
GROUP BY jahr, monat
ORDER BY anzahl_buchungen DESC;




  SELECT YEAR(FB.buchungsdatum) AS jahr, 
         FB.flughafen_id, 
         COUNT(DISTINCT FB.fahrzeug_id) AS anzahl_verschiedene_fahrzeuge
    FROM tbl_fahrzeugbuchung AS FB, tbl_flughafen AS FH, tbl_land AS L
   WHERE FB.flughafen_id = FH.id_flughafen
     AND FH.land_id = L.id_land
     AND L.kontinent = 'Nordamerika'
GROUP BY jahr, FB.flughafen_id
ORDER BY anzahl_verschiedene_fahrzeuge DESC
   LIMIT 1;


/* Bestimmen Sie pro Hotel und pro Buchungsjahr die Höhe der Einnahmen durch alle seine Zimmerbuchungen. Beachten Sie dazu in tbl_zimmerbuchung das Produkt preis_pro_tag * tage_dauer als Einnahme für nur eine einzelne Zimmerbuchung. Die Zuordnung der Buchung zu einem Buchungsjahr erfolgt über YEAR(buchungsdatum). */

  SELECT YEAR(ZB.buchungsdatum) AS jahr, 
         Z.hotel_id, 
         SUM(ZB.tage_dauer * ZB.preis_pro_tag) AS einnahmen
    FROM tbl_zimmerbuchung AS ZB, tbl_zimmer AS Z
   WHERE ZB.zimmer_id = Z.id_zimmer
GROUP BY jahr, Z.hotel_id
ORDER BY jahr ASC, einnahmen DESC;




/* Geben Sie pro Kunden und pro Hotel das früheste Datum in tbl_zimmerbuchung.von und das letzte Datum in tbL-hotelbewertung.datum an. Welcher Kunde hat eine Hotelbewertung abgegeben, noch bevor er in dem von Ihm bewerteten Hotel überhaupt irgendein Zimmer bezogen hatte? */

  SELECT ZB.kunde_id, Z.hotel_id, 
         MIN(ZB.von) AS erstes_checkin, 
         MAX(HB.datum) AS letzte_bewertung
    FROM tbl_zimmerbuchung AS ZB, tbl_zimmer AS Z, tbl_hotelbewertung AS HB
   WHERE ZB.kunde_id = HB.kunde_id
     AND ZB.zimmer_id = Z.id_zimmer
     AND Z.hotel_id = HB.hotel_id
GROUP BY ZB.kunde_id, Z.hotel_id
  HAVING letzte_bewertung < erstes_checkin;
