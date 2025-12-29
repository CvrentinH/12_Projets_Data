/*1.*/
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer 
WHERE Country != 'USA'

/*2.*/
SELECT FirstName, LastName, CustomerId, Country 
FROM Customer 
WHERE Country = 'Brazil'

/*3.*/
/*3. Factures des clients brésiliens*/
SELECT 
    c.FirstName, 
    c.LastName, 
    i.InvoiceId, 
    c.CustomerId, 
    i.BillingCountry, 
    i.InvoiceDate
FROM Customer c
JOIN Invoice i ON c.CustomerId = i.CustomerId
WHERE c.Country = 'Brazil';

/*4.*/
SELECT Title, FirstName, LastName
FROM Employee
WHERE Title="Sales Support Agent"

/*5.*/
SELECT DISTINCT BillingCountry 
FROM Invoice;

/*6.*/
SELECT e.FirstName, e.LastName,i.InvoiceId
FROM Invoice AS i
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId
LEFT JOIN Employee e ON c.SupportRepId = e.EmployeeId 

/*7.*/
SELECT i.Total, c.LastName, c.FirstName, c.Country, e.LastName, e.FirstName
FROM Invoice AS i
LEFT JOIN Customer c ON i.CustomerId = c.CustomerId
LEFT JOIN Employee e ON e.EmployeeId = c.SupportRepId

/*8.*/
SELECT 
    strftime('%Y', InvoiceDate) as Annee, 
    COUNT(*) as Nombre_Factures,
    SUM(Total) as Montant_Total
FROM Invoice
WHERE strftime('%Y', InvoiceDate) IN ('2009', '2011')
GROUP BY Annee;

/*9.*/
SELECT count(InvoiceLineId)
FROM InvoiceLine
WHERE InvoiceId = 37

/*10.*/
SELECT count(InvoiceLineId), InvoiceId
FROM InvoiceLine
GROUP BY InvoiceId

/*11.*/
SELECT t.Name, il.InvoiceLineId
FROM InvoiceLine il
LEFT JOIN Track t ON il.Trackid = t.Trackid

/*12.*/
SELECT t.Name, il.InvoiceLineId, a.Name
FROM InvoiceLine il
LEFT JOIN Track t ON il.Trackid = t.Trackid
LEFT JOIN Album al ON t.AlbumId = al.AlbumId
LEFT JOIN Artist a ON al.ArtistId = a.ArtistId

/*13.*/
SELECT BillingCountry, COUNT(InvoiceId)
FROM Invoice
GROUP BY BillingCountry;

/*14.*/
SELECT 
    p.Name AS Nom_Playlist, 
    COUNT(pt.TrackId) AS Nombre_Morceaux
FROM Playlist p
INNER JOIN PlaylistTrack pt ON p.PlaylistId = pt.PlaylistId
GROUP BY p.Name;

/*15.*/
SELECT 
    t.Name AS Morceau,
    al.Title AS Album,
    m.Name AS Media,
    g.Name AS Genre
FROM Track t
INNER JOIN Album al ON t.AlbumId = al.AlbumId
INNER JOIN MediaType m ON t.MediaTypeId = m.MediaTypeId
INNER JOIN Genre g ON t.GenreId = g.GenreId;

/*16.*/
SELECT 
    i.InvoiceId,
    COUNT(il.InvoiceLineId) as Nombre_Articles
FROM Invoice i
LEFT JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
GROUP BY i.InvoiceId;

/*17.*/
SELECT e.FirstName, e.LastName, SUM(i.Total)
FROM Employee e
JOIN Customer c on c.SupportRepId = e.EmployeeId
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC;

/*18.*/
SELECT e.FirstName, e.LastName, SUM(i.Total)
FROM Employee e
JOIN Customer c on c.SupportRepId = e.EmployeeId
JOIN Invoice i ON i.CustomerId = c.CustomerId
WHERE strftime('%Y', i.InvoiceDate) = '2021'
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC;

/*19.*/
SELECT e.FirstName, e.LastName, SUM(i.Total)
FROM Employee e
JOIN Customer c on c.SupportRepId = e.EmployeeId
JOIN Invoice i ON i.CustomerId = c.CustomerId
WHERE strftime('%Y', i.InvoiceDate) = '2022'
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC;

/*20.*/
SELECT e.FirstName, e.LastName, SUM(i.Total)
FROM Employee e
JOIN Customer c on c.SupportRepId = e.EmployeeId
JOIN Invoice i ON i.CustomerId = c.CustomerId
GROUP BY e.EmployeeId
ORDER BY SUM(i.Total) DESC;

/*21.*/
SELECT e.FirstName, e.LastName, COUNT(c.CustomerId) as Nb_Clients
FROM Employee e
JOIN Customer c ON c.SupportRepId = e.EmployeeId
GROUP BY e.EmployeeId;

/*22.*/
SELECT BillingCountry, SUM(Total) as Total_Ventes
FROM Invoice
GROUP BY BillingCountry
ORDER BY Total_Ventes DESC;

/*23.*/
SELECT t.Name, SUM(il.Quantity) as Nb_Vendus
FROM Invoice i
JOIN InvoiceLine il ON i.InvoiceId = il.InvoiceId
JOIN Track t ON il.TrackId = t.TrackId
WHERE strftime('%Y', i.InvoiceDate) = '2025'
GROUP BY t.TrackId
ORDER BY Nb_Vendus DESC;

/*24.*/
SELECT t.Name, SUM(il.Quantity) as Nb_Vendus
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
GROUP BY t.TrackId
ORDER BY Nb_Vendus DESC;

/*25.*/
SELECT 
    ar.Name, 
    SUM(il.Quantity) as Nb_Vendus
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN Album al ON t.AlbumId = al.AlbumId
JOIN Artist ar ON al.ArtistId = ar.ArtistId
GROUP BY ar.ArtistId
ORDER BY Nb_Vendus DESC
LIMIT 3;

/*26.*/
SELECT mt.Name, SUM(il.Quantity) as Nb_Vendus
FROM InvoiceLine il
JOIN Track t ON il.TrackId = t.TrackId
JOIN MediaType AS mt ON t.MediaTypeId = mt.MediaTypeId
GROUP BY mt.MediaTypeId
ORDER BY Nb_Vendus DESC;