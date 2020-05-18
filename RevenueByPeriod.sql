SELECT 
o.orderId,
t.ticketId,
ts.ticketNumber,
ts.tripId,
ts.ticketStatus,
tr.tripName,
tr.tripAbbreviation,
tr.startDate,
year(tr.startDate),
tr.endDate,
tr.public,
tr.tripCategoryId,
o.total/100 as 'GrossTicket',
o.commissionTotal/100 as 'Commission',
o.total/100 - o.commissionTotal/100  as 'NetTicket',
ii.invoiceId,
i.invoiceStatus,
i.groupId,
so.salesOfficeName as 'Sales Office Invoice',
month(tr.startDate)

FROM sdfsdfs234234_live.invoices i 
join sdfsdfs234234_live.invoice_items ii on (ii.invoiceId = i.invoiceId)
join sdfsdfs234234_live.orders o on (ii.orderid = o.orderid)
join sdfsdfs234234_live.ticket_orders t on (o.orderid = t.orderid) 
join sdfsdfs234234_live.tickets ts on (ts.ticketId = t.ticketid) 
join sdfsdfs234234_live.trips tr on (tr.tripid = i.tripid)
left join sdfsdfs234234_live.sales_offices so on (so.salesOfficeId = i.salesOfficeId)

where 
tr.startDate > '2020-02-29' 
and tr.startDate < '2020-03-16' 
and tr.triptype = 'trip'
and ts.ticketStatus in (2,3)
and tr.tripStatus = '1' 
and o.orderstatus not in (1)
and ts.tripId = i.tripid


group by
t.ticketId,
ts.ticketNumber,
ts.tripId