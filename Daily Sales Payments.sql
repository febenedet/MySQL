SELECT distinctrow
so.salesOfficeName as 'Customer',
ii.invoiceId as 'Invoice',
formaT((pa.paymentamount/100),2) as 'Amount',
pm.paymentMethod 'Payment Method',
pa.paymentDateTime as 'Purchase Date',
tr.tripName as 'Trip Name',
tr.startDate as 'Trip Start Date',
tr.tripid,
ts.ticketNotes,
pa.paymentId

FROM sdfsdfs234234_live.order_payments p
join sdfsdfs234234_live.payments pa on (pa.paymentId = p.paymentId)
join sdfsdfs234234_live.payment_methods pm on (pa.paymentMethodId = pm.paymentMethodId)
join sdfsdfs234234_live.invoice_items ii on (ii.orderid = p.orderid)
join sdfsdfs234234_live.ticket_orders t on (p.orderid = t.orderid)
join sdfsdfs234234_live.tickets ts on (ts.ticketId = t.ticketid)
join sdfsdfs234234_live.trips tr on (tr.tripid = ts.tripid)
join sdfsdfs234234_live.sales_offices so on (ts.salesofficeid = so.salesofficeid)
join sdfsdfs234234_live.orders o on (ii.orderid = o.orderid)

WHERE
ts.ticketStatus in (2,3)
and o.orderstatus not in (1)


group by pa.paymentID
