use end_module;
alter table products 
add constraint fk_products_categoryid foreign key (categoryid) references categories(categoryid),
add constraint fk_products_storeid foreign key (storeid) references stores(storeid);

alter table images 
add constraint fk_images_productid foreign key (productid) references products(productid);

alter table reviews 
add constraint fk_reviews_userid foreign key (userid) references users(userid),
add constraint fk_reviews_productid foreign key (productid) references products(productid);

alter table carts 
add constraint fk_carts_userid foreign key (userid) references users(userid),
add constraint fk_carts_productid foreign key (productid) references products(productid);

alter table order_details 
add constraint fk_order_details_productid foreign key (productid) references products(productid),
add constraint fk_order_details_orderid foreign key (orderid) references orders(orderid);

alter table orders 
add constraint fk_orders_userid foreign key (userid) references users(userid),
add constraint fk_orders_storeid foreign key (storeid) references stores(storeid);

alter table stores 
add constraint fk_stores_userid foreign key (userid) references users(userid);

-- Liệt kê tất cả các thông tin về sản phẩm
select * from products;

-- Tìm tất cả các đơn hàng có tổng giá trị lớn hơn 500,000
select * from orders
where totalprice > 500000;

-- Liệt kê tên và địa chỉ của tất cả các cửa hàng
select storename, addressstore from stores;

-- Tìm tất cả người dùng có địa chỉ email kết thúc bằng '@gmail.com'
select * from users
where email like '%@gmail.com';

-- Hiển thị tất cả các đánh giá (reviews) với mức đánh giá (rate) bằng 5
select * from reviews
where rate = 5;

-- Liệt kê tất cả các sản phẩm có số lượng (quantity) dưới 10
select * from products
where quantity < 10;

-- Tìm tất cả các sản phẩm thuộc danh mục categoryId = 1
select * from products
where categoryid = 1;
-- Đếm số lượng người dùng (users) có trong hệ thống
select count(*) as total_users from users;

-- Tính tổng giá trị của tất cả các đơn hàng (orders)
select sum(totalprice) as total_order_value from orders;

-- Tìm sản phẩm có giá cao nhất (price)
select * from products
where price = (select max(price) from products);

-- Liệt kê tất cả các cửa hàng đang hoạt động (statusStore = 1)
select * from stores
where statusstore = 1;

-- Đếm số lượng sản phẩm theo từng danh mục (categories)
select c.categoryname, count(p.productid) as product_count
from categories c
left join products p on c.categoryid = p.categoryid
group by c.categoryname
-- tìm tất cả các sản phẩm chưa từng có đánh giá
select p.productid, p.productname
from products p
left join reviews r on p.productid = r.productid
where r.reviewid is null;

-- hiển thị tổng số lượng hàng đã bán (quantityorder) của từng sản phẩm
select p.productid, p.productname, sum(od.quantityorder) as totalquantitysold
from products p
join order_details od on p.productid = od.productid
group by p.productid;

-- tìm các người dùng chưa đặt bất kỳ đơn hàng nào
select u.userid, u.username
from users u
left join orders o on u.userid = o.userid
where o.orderid is null;

-- hiển thị tên cửa hàng và tổng số đơn hàng được thực hiện tại từng cửa hàng
select s.storename, count(o.orderid) as totalorders
from stores s
left join orders o on s.storeid = o.storeid
group by s.storeid;

-- hiển thị thông tin của sản phẩm, kèm số lượng hình ảnh liên quan
select p.productid, p.productname, count(i.imageid) as imagecount
from products p
left join images i on p.productid = i.productid
group by p.productid;

-- hiển thị các sản phẩm kèm số lượng đánh giá và đánh giá trung bình
select p.productid, p.productname, count(r.reviewid) as reviewcount, avg(r.rate) as averagerating
from products p
left join reviews r on p.productid = r.productid
group by p.productid;

-- tìm người dùng có số lượng đánh giá nhiều nhất
select u.userid, u.username, count(r.reviewid) as reviewcount
from users u
join reviews r on u.userid = r.userid
group by u.userid
order by reviewcount desc
limit 1;

-- hiển thị top 3 sản phẩm bán chạy nhất (dựa trên số lượng đã bán)
select p.productid, p.productname, sum(od.quantityorder) as totalquantitysold
from products p
join order_details od on p.productid = od.productid
group by p.productid
order by totalquantitysold desc
limit 3;

-- tìm sản phẩm bán chạy nhất tại cửa hàng có storeid = 'S001'
select p.productid, p.productname, sum(od.quantityorder) as totalquantitysold
from products p
join order_details od on p.productid = od.productid
join orders o on od.orderid = o.orderid
where o.storeid = 'S001'
group by p.productid
order by totalquantitysold desc
limit 1;

-- hiển thị danh sách tất cả các sản phẩm có giá trị tồn kho lớn hơn 1 triệu (giá * số lượng)
select p.productid, p.productname, p.price, p.quantity, (p.price * p.quantity) as stockvalue
from products p
where (p.price * p.quantity) > 1000000;
-- tìm cửa hàng có tổng doanh thu cao nhất
select o.storeid, sum(od.quantityorder * od.priceorder) as totalrevenue
from orders o
join order_details od on o.orderid = od.orderid
group by o.storeid
order by totalrevenue desc
limit 1;

-- hiển thị danh sách người dùng và tổng số tiền họ đã chi tiêu
select u.userid, u.username, sum(od.quantityorder * od.priceorder) as totalspent
from users u
join orders o on u.userid = o.userid
join order_details od on o.orderid = od.orderid
group by u.userid;

-- tìm đơn hàng có tổng giá trị cao nhất và liệt kê thông tin chi tiết
select o.orderid, o.userid, o.storeid, o.totalprice, od.productid, od.quantityorder, od.priceorder
from orders o
join order_details od on o.orderid = od.orderid
order by o.totalprice desc
limit 1;

-- tính số lượng sản phẩm trung bình được bán ra trong mỗi đơn hàng
select avg(order_detail_count) as avg_product_per_order
from (
    select count(od.productid) as order_detail_count
    from order_details od
    group by od.orderid
) as order_counts;

-- hiển thị tên sản phẩm và số lần sản phẩm đó được thêm vào giỏ hàng
select p.productid, p.productname, count(c.cartid) as cartcount
from products p
join carts c on p.productid = c.productid
group by p.productid;

-- tìm tất cả các sản phẩm đã bán nhưng không còn tồn kho trong kho hàng
select p.productid, p.productname, p.quantity
from products p
join order_details od on p.productid = od.productid
group by p.productid
having sum(od.quantityorder) > p.quantity;

-- tìm các đơn hàng được thực hiện bởi người dùng có email là 'duong@gmail.com'
select o.orderid, o.userid, o.storeid, o.totalprice, o.createddateorder
from orders o
join users u on o.userid = u.userid
where u.email = 'duong@gmail.com';

-- hiển thị danh sách các cửa hàng kèm theo tổng số lượng sản phẩm mà họ sở hữu
select s.storeid, s.storename, count(p.productid) as productcount
from stores s
left join products p on s.storeid = p.storeid
group by s.storeid;

-- EX4
-- Tạo view expensive_products để hiển thị tên sản phẩm và giá trị giá lớn hơn 500,000
CREATE VIEW expensive_products AS
SELECT productname, price
FROM products
WHERE price > 500000;

-- Truy vấn dữ liệu từ view expensive_products
SELECT * FROM expensive_products;

-- Cập nhật giá sản phẩm trong bảng products (view expensive_products sẽ tự động phản ánh thay đổi này)
UPDATE products
SET price = 600000
WHERE productname = 'Product A' AND price > 500000;

-- Xóa view expensive_products
DROP VIEW IF EXISTS expensive_products;

-- Tạo view product_categories để hiển thị tên sản phẩm và tên danh mục
CREATE VIEW product_categories AS
SELECT p.productname, c.categoryname
FROM products p
JOIN categories c ON p.categoryid = c.categoryid;

