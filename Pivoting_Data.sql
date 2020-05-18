SELECT
primary_product_id,
count(distinct case when items_purchased = 1 then order_id else null end) as CountSingleItemOrder,
count(distinct case when items_purchased = 2 then order_id else null end) as CountTwoItemsOrder

from orders

group by 1
order by 3 desc