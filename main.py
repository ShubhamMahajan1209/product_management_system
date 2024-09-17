import mysql.connector
from mysql.connector import Error
from prettytable import PrettyTable
from datetime import datetime

# Function to establish a connection to the MySQL database
def create_connection():
    try:
        connection = mysql.connector.connect(
            host="localhost",
            user="root",
            password="Mysql@12",
            buffered=True
        )
        if connection.is_connected():
            print("Connected to MySQL database")
            return connection
    except Error as e:
        print(f"Error: {e}")
        return None


# Function to close the database connection
def close_connection(connection):
    if connection.is_connected():
        connection.close()
        print("Connection closed")


# Function to execute SQL queries
def execute_query(connection, query, data=None):
    try:
        cursor = connection.cursor()
        if data:
            cursor.execute(query, data)
        else:
            cursor.execute(query)
        connection.commit()
        return cursor
    except Error as e:
        print(f"Error: {e}")
        return None

def execute_query_fetchone(connection, query):
    cursor = connection.cursor()
    cursor.execute(query)
    result = cursor.fetchone()
    cursor.close()
    return result

def main():
    connection = create_connection()
    cursor_1 = connection.cursor()
    cursor_1.execute('use rdbmsproject')

    print("\n--- E-commerce Website Database Mangement System ---")

    print("\n--- View Feature ---")
    print("1. Display User Information")
    print("2. Display Products Available")
    print("3. Display Orders Placed")
    print("4. Display Payments")
    print("5. Display Product Reviews")
    print("6. Display Items Ordered Details")

    print("\n--- Input Management ---")
    print("7. Add User")
    print("8. Add Product")
    print("9. Add Review")

    print("\n--- Order Placement ---")
    print("10. Place an Order")
    print("\n--- Exit ---")
    print("11. Exit")

    while True:
        choice = input("\nEnter your choice (1-11): ")

        if choice == "1":
            display_user_information(connection)
        elif choice == "2":
            display_product_information(connection)
        elif choice == "3":
            display_orders_placed(connection)
        elif choice == "4":
            display_payments(connection)
        elif choice == "5":
            display_product_reviews(connection)
        elif choice == "6":
            display_items_ordered_details(connection)
        elif choice == "7":
            add_user(connection)
        elif choice == "8":
            add_product(connection)
        elif choice == "9":
            add_review(connection)
        elif choice == "10":
            place_order(connection)
        elif choice == "11":
            close_connection(connection)
            print("Exiting. Goodbye!")
            break
        else:
            print("Invalid choice. Please enter a number between 1 and 19.")


def display_user_information(connection):
    query = "SELECT Username, Email, Phone_number, Address_line1, Address_line2, City, State, Country, PostalCode FROM USER JOIN ADDRESS ON user.user_id = address.user_user_id";
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- User Information ---")
        table = PrettyTable()
        table.field_names = ["Username", "Email", "Phone Number", "Address Line 1", "Address Line 2", "City", "State", "Country", "Postal Code"]
        for row in my_c.fetchall():
            table.add_row([row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8]])
        print(table)


def display_product_information(connection):
    query = "SELECT * FROM product JOIN category ON product.category_Category_ID = category.category_id;"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Product Information ---")
        table = PrettyTable()
        table.field_names = ["Product ID", "Product Name", "Description", "Price", "Stock Quantity", "Category"]
        for row in my_c.fetchall():
            table.add_row([row[0],row[1], row[2], row[3], row[4], row[7]])
        print(table)

def display_orders_placed(connection):
    query = "select * from orders join user on orders.user_User_ID=user.user_id;"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Order Placed ---")
        table = PrettyTable()
        table.field_names = ["Username", "Date", "Total_Amount", "Email_ID"]
        for row in my_c.fetchall():
            table.add_row([row[5], row[1], row[2], row[6]])
        print(table)

def display_payments(connection):
    query = "select * from payment join user on payment.user_User_ID=user.user_id join orders on payment.orders_Order_ID =orders.order_id;"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Payments ---")
        table = PrettyTable()
        table.field_names = ["Username", "Order_Date", "Payment_Date", "Total_Amount","Payment_Method"]
        for row in my_c.fetchall():
            table.add_row([row[7], row[12], row[2], row[1], row[3]])
        print(table)

def display_product_reviews(connection):
    query = "select * from review join user on review.user_User_ID=user.user_ID join product on review.product_product_id=product.product_id;"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Product Reviews ---")
        table = PrettyTable()
        table.field_names = ["Product", "Rating", "Description", "Review_Date","Username"]
        for row in my_c.fetchall():
            table.add_row([row[12], row[1], row[2], row[3], row[7]])
        print(table)

def display_items_ordered_details(connection):
    query = "select * from orderitem join orders on orderitem.orders_order_id=orders.order_id join user on orderitem.orders_user_user_id=user.user_id join product on orderitem.product_product_id=product.product_id;"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Items Ordered Details ---")
        table = PrettyTable()
        table.field_names = ["Product", "Username",  "Price", "Quantity", "Total", "Stock_Quantity", "Order_Date"]
        for row in my_c.fetchall():
            table.add_row([row[16], row[11], row[18], row[1], row[2], row[19], row[7]])
        print(table)

def add_user(connection):
    print("\n--- Add User ---")
    username = input("Enter Username: ")
    emailid = input("Enter Email Address: ")
    password = input("Enter Password: ")
    contact_no = input("Enter Contact Number: ")
    addressline1 = input("Enter Address line1: ")
    addressline2 = input("Enter Address line2: ")
    city= input("Enter City: ")
    state = input("Enter State: ")
    country = input("Enter Country: ")
    postalcode = input("Enter Postal code: ")

    query_last_id = "SELECT MAX(User_id) FROM USER"
    last_id = execute_query_fetchone(connection, query_last_id)[0]
    user_id = last_id + 1 if last_id else 1

    query_last_id = "SELECT MAX(address_id) FROM address"
    last_id = execute_query_fetchone(connection, query_last_id)[0]
    address_id = last_id + 1 if last_id else 1

    data = (user_id,username, emailid, password, contact_no)
    query = "INSERT INTO USER (User_id, Username, email, password, phone_number) VALUES (%s, %s, %s, %s, %s)"
    execute_query(connection, query, data)

    data = (address_id, addressline1, addressline2, city, state, country, postalcode, user_id)
    query = "INSERT INTO Address (address_id, address_line1, address_line2, city, state, country, postalcode, user_user_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    execute_query(connection, query, data)
    print("User added successfully.")

def close_connection(connection):
    if connection.is_connected():
        connection.close()
        print("Connection closed")



def add_product(connection):
    print("\n--- Add Product ---")
    product_name = input("Enter Product Name: ")
    description = input("Enter Product Description: ")
    price = float(input("Enter Product Price: "))
    stock_quantity = int(input("Enter Stock Quantity: "))

    # Display existing categories
    print("\nExisting Categories:")
    display_categories(connection)

    # Ask user whether to add to existing category or create a new one
    while True:
        option = input(
            "\nDo you want to (1) add to an existing category or (2) create a new category and add to it? (1/2): ")
        if option == "1":
            category_id = choose_category(connection)
            break
        elif option == "2":
            category_id = create_new_category(connection)
            break
        else:
            print("Invalid option. Please choose either 1 or 2.")

    # Generate new product ID with category prefix
    product_id = generate_product_id(connection, category_id)

    # Insert product into the database
    data = (product_id, product_name, description, price, stock_quantity, category_id)
    query = "INSERT INTO product (Product_ID, Product_Name, Description, Price, Stock_Quantity, category_Category_ID) VALUES (%s, %s, %s, %s, %s, %s)"
    execute_query(connection, query, data)
    print("Product added successfully.")


def generate_product_id(connection, category_id):
    # Fetch the count of products in the given category
    query = "SELECT COUNT(*) FROM product WHERE category_Category_ID = %s"
    cursor = connection.cursor()
    cursor.execute(query, (category_id,))
    product_count = cursor.fetchone()[0]

    # Generate the product ID with category prefix and padded with zeros
    product_id = f"{category_id}{product_count + 1:03}"
    return product_id


def choose_category(connection):
    while True:
        category_id = input("Enter the ID of the category to add the product to: ")
        query = "SELECT * FROM category WHERE Category_ID = %s"
        cursor = connection.cursor()
        cursor.execute(query, (category_id,))
        category = cursor.fetchone()
        if category:
            return category_id
        else:
            print("Invalid category ID. Please choose a valid ID.")


def create_new_category(connection):
    category_name = input("Enter the name of the new category: ")
    # Generate new category ID
    query_last_id = "SELECT MAX(Category_ID) FROM category"
    last_id = execute_query_fetchone(connection, query_last_id)[0]
    category_id = last_id + 1 if last_id else 1
    # Insert new category into the database
    data = (category_id, category_name)
    query = "INSERT INTO category (Category_ID, Category_Name) VALUES (%s, %s)"
    execute_query(connection, query, data)
    print("New category added successfully.")
    return category_id

def display_categories(connection):
    query = "select * from category"
    my_c = connection.cursor()
    my_c.execute(query)
    if my_c:
        print("\n--- Category Details ---")
        table = PrettyTable()
        table.field_names = ["Sr.No", "Category"]
        for row in my_c.fetchall():
            table.add_row([row[0], row[1]])
        print(table)


def add_review(connection):
    print("\n--- Add Review ---")

    # Confirm user's information
    username = input("Enter Username: ")
    email = input("Enter Email: ")
    password = input("Enter Password: ")

    user_id = confirm_user(connection, username, email, password)
    if not user_id:
        print("User not found. Cannot add review.")
        return
    display_product_information(connection)
    # Prompt user to enter product ID
    product_id = input("Enter Product ID: ")
    if not is_valid_product(connection, product_id):
        print("Invalid Product ID. Cannot add review.")
        return

    # Prompt user to enter rating and comment
    rating = int(input("Enter Rating (1-5): "))
    if not (1 <= rating <= 5):
        print("Invalid Rating. Rating must be between 1 and 5.")
        return
    comment = input("Enter Review Comment: ")

    review_date = datetime.now().date()

    review_id = get_next_review_id(connection)

    # Insert review into the database
    data = (review_id, rating, comment, review_date, user_id, product_id)
    query = "INSERT INTO review (review_id, Rating, Comment, Review_Date, user_User_ID, product_Product_ID) VALUES (%s, %s, %s, %s, %s, %s)"
    execute_query(connection, query, data)
    print("Review added successfully.")


def get_next_review_id(connection):
    query = "SELECT MAX(review_id) FROM review"
    last_id = execute_query_fetchone(connection, query)[0]
    return last_id + 1 if last_id else 1

def is_valid_product(connection, product_id):
    query = "SELECT Product_ID FROM product WHERE Product_ID = %s"
    cursor = connection.cursor()
    cursor.execute(query, (product_id,))
    product = cursor.fetchone()
    if product:
        return True
    else:
        return False




def place_order(connection):
    print("\n--- Place Order ---")

    # Confirm user's information
    username = input("Enter Username: ")
    email = input("Enter Email: ")
    password = input("Enter Password: ")

    user_id = confirm_user(connection, username, email, password)
    if not user_id:
        print("User not found. Adding user to the database...")
        add_user(connection)
        user_id = confirm_user(connection, username, email, password)
        if not user_id:
            print("Failed to add user. Please try again later.")
            return

    # Display available products
    print("\nAvailable Products:")
    display_product_information(connection)

    # Get product and quantity from user
    order_items = []
    while True:
        product_id = input("\nEnter Product ID (0 to stop): ")
        if product_id == '0':
            break
        quantity = int(input("Enter Quantity: "))
        order_items.append((product_id, quantity))

    # Confirm order
    print("\nOrder Summary:")
    total_amount = 0
    for product_id, quantity in order_items:
        product_name, price = get_product_info(connection, product_id)
        subtotal = price * quantity
        print(f"Product: {product_name}, Quantity: {quantity}, Subtotal: ${subtotal:.2f}")
        total_amount += subtotal

    print(f"\nTotal Amount: ${total_amount:.2f}")
    payment_method = input("Enter Payment Method: ")

    # Insert order into orders table
    query_last_id = "SELECT MAX(order_id) FROM orders"
    last_id = execute_query_fetchone(connection, query_last_id)[0]
    order_id = last_id + 1 if last_id else 1
    order_date = datetime.now().date()
    data = (order_id, order_date, total_amount, user_id)
    query = "INSERT INTO orders (Order_ID ,Order_Date, Total_Amount, user_User_ID) VALUES (%s, %s, %s, %s)"
    execute_query(connection, query, data)

    # Insert order items into orderitem table
    for product_id, quantity in order_items:
        query_last_id = "SELECT MAX(orderitem_id) FROM orderitem"
        last_id = execute_query_fetchone(connection, query_last_id)[0]
        orderitem_id = last_id + 1 if last_id else 1
        data = (orderitem_id, quantity, (quantity * get_product_price(connection, product_id)), order_id, user_id, product_id)
        query = "INSERT INTO orderitem (orderitem_id, Quantity, Subtotal, orders_Order_ID, orders_user_User_ID, product_Product_ID) VALUES (%s, %s, %s, %s, %s, %s)"
        execute_query(connection, query, data)

        # Update stock quantity
        update_stock_quantity(connection, product_id, quantity)

    # Insert payment information into payment table
    query_last_id = "SELECT MAX(payment_id) FROM payment"
    last_id = execute_query_fetchone(connection, query_last_id)[0]
    payment_id = last_id + 1 if last_id else 1
    data = (payment_id,total_amount, datetime.now().date(), payment_method, user_id, order_id)
    query = "INSERT INTO payment (Payment_id ,Amount, Payment_Date, Payment_Method, user_User_ID, orders_Order_ID) VALUES (%s, %s, %s, %s, %s, %s)"
    execute_query(connection, query, data)

    print("Order placed successfully.")


def confirm_user(connection, username, email, password):
    query = "SELECT User_ID FROM user WHERE Username = %s AND Email = %s AND Password = %s"
    cursor = connection.cursor()
    cursor.execute(query, (username, email, password))
    user = cursor.fetchone()
    if user:
        return user[0]
    else:
        return None


def get_product_info(connection, product_id):
    query = "SELECT Product_Name, Price FROM product WHERE Product_ID = %s"
    cursor = connection.cursor()
    cursor.execute(query, (product_id,))
    product = cursor.fetchone()
    if product:
        return product[0], product[1]
    else:
        return None, None


def get_product_price(connection, product_id):
    query = "SELECT Price FROM product WHERE Product_ID = %s"
    cursor = connection.cursor()
    cursor.execute(query, (product_id,))
    price = cursor.fetchone()
    if price:
        return price[0]
    else:
        return None


def update_stock_quantity(connection, product_id, quantity):
    current_quantity = get_product_stock_quantity(connection, product_id)
    new_quantity = current_quantity - quantity
    query = "UPDATE product SET Stock_Quantity = %s WHERE Product_ID = %s"
    data = (new_quantity, product_id)
    execute_query(connection, query, data)
    print(f"Stock quantity for product ID {product_id} updated successfully.")


def get_product_stock_quantity(connection, product_id):
    query = "SELECT Stock_Quantity FROM product WHERE Product_ID = %s"
    cursor = connection.cursor()
    cursor.execute(query, (product_id,))
    stock_quantity = cursor.fetchone()
    if stock_quantity:
        return stock_quantity[0]
    else:
        return None


if __name__ == '__main__':
    main()