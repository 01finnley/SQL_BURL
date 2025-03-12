/* 
Aufgabe 1

Bestimmen Sie pro Buchungsdatum die Anzahl der Zimmerbuchungen für alle Hotels zusammengenommen. Geben Sie das Buchungsdatum in tbl_zimmerbuchung, an dem die höchste Gesamtanzahl an Zimmern gebucht wurde.

*/

SELECT ZB1.buchungsdatum, COUNT(ZB1.id_zimmerbuchung) AS anz_buchungen
  FROM tbl_zimmerbuchung AS ZB1, tbl_zimmerbuchung AS ZB2
 WHERE ZB1.buchungsdatum = ZB2.buchungsdatum
 GROUP BY ZB1.buchungsdatum
HAVING COUNT(ZB1.id_zimmerbuchung) >= ALL (
         SELECT COUNT(ZB3.id_zimmerbuchung)
           FROM tbl_zimmerbuchung AS ZB3, tbl_zimmerbuchung AS ZB4
          WHERE ZB3.buchungsdatum = ZB4.buchungsdatum
          GROUP BY ZB3.buchungsdatum
       );


/*
Aufgabe 2
Geben Sie pro Kalenderjahr die Anzahl der Flugbuchungen an. Die Zuordnung einer Buchung zu einem Kalenderjahr erfolgt durch YEAR(buchungsdatum). Geben Sie nur die maximale Anzahl von Flugbuchungen an, die jemals in einem einzelnen Kalenderjahr erreicht wurde.

*/

  SELECT MAX(anzahl_buchungen) AS max_buchungen
    FROM (
          SELECT YEAR(buchungsdatum) AS jahr, COUNT(id_flugbuchung) AS anzahl_buchungen
            FROM tbl_flugbuchung AS FB
           GROUP BY YEAR(buchungsdatum)
         ) AS buchungen_pro_jahr;


/*
Aufgabe 3

Geben Sie pro Kunde die Gesamtkunden aller seiner Zimmerbuchungen an. Beachten Sie dazu in tbl_zimmerbuchung das Produkt preis_pro_tag * tage_dauer für eine einzelne Zimmerbuchung. Wie viele Kunden haben für alle ihre Zimmerbuchung insgesamt mehr als 10000€ gezahlt?

*/

  SELECT COUNT(KB.kunde_id) AS anzahl_kunden
    FROM (
          SELECT ZB.kunde_id, SUM(ZB.preis_pro_tag * ZB.tage_dauer) AS gesamt_kosten
            FROM tbl_zimmerbuchung AS ZB
           GROUP BY ZB.kunde_id
          HAVING SUM(ZB.preis_pro_tag * ZB.tage_dauer) > 10000
         ) AS KB;


/*
Aufgabe 4

Geben Sie pro Flug die Anzahl der Buchungen an. Wann startete der erste Flug mit nur genau 10 Buchungen?

*/

  SELECT F.start_datum
    FROM tbl_flugbuchung AS FB, tbl_flug AS F
   WHERE FB.flug_id = F.id_flug
   GROUP BY FB.flug_id
  HAVING COUNT(FB.id_flugbuchung) = 10
ORDER BY F.start_datum ASC
   LIMIT 1;


/*
Aufgabe 5

Es gibt eine Hotelkette, bei der alle Hotelnamen mit "Four Seasons Hotel" beginnen. Bestimmen Sie nur für alle diese "Four Seasons Hotels" die Anzahl der jeweiligen Zimmerbuchungen. Welches Hotel dieser Kette hat einzeln für sich die meisten Zimmerbuchungen erhalten? Geben Sie nur die maximale Anzahl der Zimmerbuchungen an (aber nicht die id_hotel).

*/

  SELECT MAX(anz_buchungen) AS max_zimmerbuchungen
    FROM (
          SELECT H.id_hotel, COUNT(ZB.id_zimmerbuchung) AS anz_buchungen
            FROM tbl_hotel AS H, tbl_zimmer AS Z, tbl_zimmerbuchung AS ZB
           WHERE H.id_hotel = Z.hotel_id
             AND Z.id_zimmer = ZB.zimmer_id
             AND H.name LIKE 'Four Seasons Hotel%'
        GROUP BY H.id_hotel
         ) AS buchungen_pro_hotel;


/*
Aufgabe 6

Geben Sie pro Kunde, pro Hotel und pro Zimmer an, wie oft das Zimmer gebucht wurde. Wie viele Kunden haben im selben Hotel zumindest zweimal das selbe Zimmer gebucht?

*/

  SELECT ZB.kunde_id, Z.hotel_id, ZB.zimmer_id, COUNT(ZB.id_zimmerbuchung) AS buchungen
    FROM tbl_zimmerbuchung AS ZB, tbl_zimmer AS Z, tbl_hotel AS H
   WHERE ZB.zimmer_id = Z.id_zimmer
     AND Z.hotel_id = H.id_hotel
GROUP BY ZB.kunde_id, Z.hotel_id, ZB.zimmer_id;
