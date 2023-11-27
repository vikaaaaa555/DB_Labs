import psycopg2

connection = psycopg2.connect(
    user="postgres",
    password="vika5972",
    host="localhost",
    database="myDB"
)


def register_user():
    print("Registration:")
    login = input("Enter your login: ")
    password = input("Enter your password: ")

    try:
        with connection.cursor() as cursor:
            cursor.execute("INSERT INTO users (login, password, role_id) VALUES (%s, %s, %s) RETURNING id",
                           (login, password, 3))
            user_id = cursor.fetchone()[0]
            connection.commit()
            print(f"Registration successful! Your user ID is {user_id}.")
            return user_id, login
    except Exception as e:
        print(f"Error: Unable to register user\n{e}")
        return None


def login_user():
    login = input("Enter your login: ")
    password = input("Enter your password: ")

    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT id, role_id FROM users WHERE login = %s AND password = %s", (login, password))
            user = cursor.fetchone()

            query = """
                SELECT u.id, u.role_id, r.role_type
                FROM users u
                JOIN role r ON u.role_id = r.id
                WHERE u.login = %s;
                """
            with connection.cursor() as cursor:
                cursor.execute(query, (login,))
                user = cursor.fetchone()

            if user:
                print(f"Login successful! Your role is {user[2]}.")
                return user[0], login
            else:
                print("Login failed. Invalid username or password.")
                return None

    except Exception as e:
        print(f"Error: Unable to log in\n{e}")

    return None


def check_role(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT role_id FROM users WHERE id = %s::integer", (user_id,))
            result = cursor.fetchone()

            if result and result[0] == 1:
                return 1
            elif result and result[0] == 2:
                return 2
            else:
                return 3
    except Exception as e:
        print(f"Error checking user role: {e}")
        return 3


def delete_user_by_id(admin_id):
    try:
        user_id_to_delete = int(input("Enter the user ID to delete: "))

        if user_id_to_delete == 1:
            raise ValueError("Cannot delete the user with ID 1.")

        with connection.cursor() as cursor:
            cursor.execute("DELETE FROM profile WHERE user_id = %s", (user_id_to_delete,))
            connection.commit()

            cursor.execute("DELETE FROM users WHERE id = %s", (user_id_to_delete,))
            connection.commit()

        print(f"User with ID {user_id_to_delete} deleted successfully.")
    except ValueError as ve:
        print(f"Error: {ve}")
    except Exception as e:
        print(f"Error deleting user: {e}")


def view_profile(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM profile WHERE user_id = %s", (user_id,))
            profile = cursor.fetchone()

            if profile:
                print("Profile:")
                print(f"First name: {profile[1]}")
                print(f"Last name: {profile[2]}")
                print(f"Email: {profile[3]}")
                print(f"Phone number: {profile[4]}")
                print(f"Birth date: {profile[5]}")
            else:
                print("Profile not found.")

        connection.commit()
    except Exception as e:
        print(f"Error: Unable to view profile\n{e}")

    connection.commit()


def edit_profile(user_id):
    while True:
        print("Edit Profile:")
        print("1. Change name")
        print("2. Change last name")
        print("3. Change email")
        print("4. Change phone number")
        print("5. Change birth date")
        print("0. Back")

        choice = input("Enter your choice: ")

        try:
            with connection.cursor() as cursor:
                if choice == '1':
                    new_name = input("Enter your new name: ")
                    cursor.execute("UPDATE profile SET first_name = %s WHERE user_id = %s", (new_name, user_id))
                    connection.commit()
                    print("Name updated successfully.")
                elif choice == '2':
                    new_last_name = input("Enter your new last name: ")
                    cursor.execute("UPDATE profile SET last_name = %s WHERE user_id = %s", (new_last_name, user_id))
                    connection.commit()
                    print("Last name updated successfully.")
                elif choice == '3':
                    new_email = input("Enter your new email: ")
                    cursor.execute("UPDATE profile SET email = %s WHERE user_id = %s", (new_email, user_id))
                    connection.commit()
                    print("Email updated successfully.")
                elif choice == '4':
                    new_phone_number = input("Enter your new phone number: ")
                    cursor.execute("UPDATE profile SET phone_number = %s WHERE user_id = %s",
                                   (new_phone_number, user_id))
                    connection.commit()
                    print("Phone number updated successfully.")
                elif choice == '5':
                    new_birth_date = input("Enter your new birth date: ")
                    cursor.execute("UPDATE profile SET birth_date = %s WHERE user_id = %s", (new_birth_date, user_id))
                    connection.commit()
                    print("Birth date updated successfully.")
                elif choice == '0':
                    print("Returning to the main menu.")
                    return
                else:
                    print("Invalid choice. Please try again.")
        except Exception as e:
            print(f"Error: Unable to edit profile\n{e}")


def change_user_role(admin_id):
    try:
        user_id_to_change = int(input("Enter the user ID to change the role: "))
        new_role = int(input("Enter the new role (2 for archiver): "))

        with connection.cursor() as cursor:
            if user_id_to_change == admin_id:
                raise ValueError("Cannot change the role for the admin.")

            update_query = "UPDATE users SET role_id = %s WHERE id = %s"
            cursor.execute(update_query, (new_role, user_id_to_change))
            print(f"User role updated successfully for user ID {user_id_to_change}.")
    except ValueError as ve:
        print(f"Error: {ve}")
    except Exception as e:
        print(f"Error changing user role: {e}")
    connection.commit()


def view_collections(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM collection")
            collections = cursor.fetchall()

            if collections:
                print("Collections:")
                for collection in collections:
                    print(f"ID: {collection[0]}, Name: {collection[1]}, Description: {collection[2]}")

                collection_id = input("Enter the ID of the collection to view documents (0 to go back): ")

                if collection_id != '0':
                    view_documents(user_id, collection_id)
            else:
                print("No collections found.")
    except Exception as e:
        print(f"Error: Unable to view collections\n{e}")


def edit_collection(user_id):
    while True:
        print("Edit collection:")
        print("1. Change title")
        print("2. Change description")
        print("0. Back")

        choice = input("Enter your choice: ")

        try:
            with connection.cursor() as cursor:
                if choice == '1':
                    new_title = input("Enter your new title: ")
                    cursor.execute("UPDATE collection SET title = %s WHERE id = %s", (new_title, user_id))
                    connection.commit()
                    print("Title updated successfully.")
                elif choice == '2':
                    new_description = input("Enter your new last name: ")
                    cursor.execute("UPDATE collection SET description = %s WHERE id = %s", (new_description, user_id))
                    connection.commit()
                    print("Description updated successfully.")
                elif choice == '0':
                    print("Returning to the main menu.")
                    return
                else:
                    print("Invalid choice. Please try again.")
        except Exception as e:
            print(f"Error: Unable to edit profile\n{e}")


def view_documents(user_id, collection_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT d.id, d.title
                FROM document d
                JOIN collection_doc_link cdl ON d.id = cdl.document_id
                WHERE cdl.collection_id = %s
            """, (collection_id,))
            documents = cursor.fetchall()

            if documents:
                print("Documents:")
                for document in documents:
                    print(f"ID: {document[0]}, Title: {document[1]}")

                document_id = input("Enter the ID of the document to view details (0 to go back): ")

                if document_id != '0':
                    view_document_details(user_id, document_id)
            else:
                print("No documents found.")
    except Exception as e:
        print(f"Error: Unable to view documents\n{e}")


def view_document_details(user_id, document_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("""
                SELECT title, description
                FROM document
                WHERE id = %s
            """, (document_id,))
            document = cursor.fetchone()

            if document:
                print(f"Title: {document[0]}\nDescription: {document[1]}")
            else:
                print("Document not found.")
    except Exception as e:
        print(f"Error: Unable to view document details\n{e}")


def view_countries(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM country")
            countries = cursor.fetchall()

            if countries:
                print("Countries:")
                for country in countries:
                    print(f"ID: {country[0]}, Name: {country[1]}, Capital: {country[2]}")
            else:
                print("No collections found.")
    except Exception as e:
        print(f"Error: Unable to view collections\n{e}")


def edit_country(user_id):
    while True:
        print("Edit country:")
        print("1. Change name")
        print("2. Change capital")
        print("0. Back")

        choice = input("Enter your choice: ")

        try:
            with connection.cursor() as cursor:
                if choice == '1':
                    new_name = input("Enter your new name: ")
                    cursor.execute("UPDATE country SET name = %s WHERE id = %s", (new_name, user_id))
                    connection.commit()
                    print("Name updated successfully.")
                elif choice == '2':
                    new_capital = input("Enter your new capital: ")
                    cursor.execute("UPDATE country SET capital = %s WHERE id = %s", (new_capital, user_id))
                    connection.commit()
                    print("Capital updated successfully.")
                elif choice == '0':
                    print("Returning to the main menu.")
                    return
                else:
                    print("Invalid choice. Please try again.")
        except Exception as e:
            print(f"Error: Unable to edit profile\n{e}")


def view_historical_figures(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT * FROM historical_figure")
            historical_figures = cursor.fetchall()

            if historical_figures:
                print("Historical Figures:")
                for historical_figure in historical_figures:
                    print(
                        f"ID: {historical_figure[0]}, Name: {historical_figure[1]}, Last name: {historical_figure[2]}, "
                        f"Birth date: {historical_figure[3]}, Death date: {historical_figure[4]}")
            else:
                print("No historical figures found.")
    except Exception as e:
        print(f"Error: Unable to view historical figures\n{e}")


def edit_historical_figure(user_id):
    while True:
        print("Edit collection:")
        print("1. Change name")
        print("2. Change last name")
        print("3. Change birth date")
        print("4. Change death date")
        print("0. Back")

        choice = input("Enter your choice: ")

        try:
            with connection.cursor() as cursor:
                if choice == '1':
                    new_title = input("Enter your new title: ")
                    cursor.execute("UPDATE historical_figure SET first_name = %s WHERE id = %s", (new_title, user_id))
                    connection.commit()
                    print("Name updated successfully.")
                elif choice == '2':
                    new_description = input("Enter your new last name: ")
                    cursor.execute("UPDATE historical_figure SET last_name = %s WHERE id = %s",
                                   (new_description, user_id))
                    connection.commit()
                    print("Last name updated successfully.")
                elif choice == '3':
                    new_description = input("Enter your new last name: ")
                    cursor.execute("UPDATE historical_figure SET birth_date = %s WHERE id = %s",
                                   (new_description, user_id))
                    connection.commit()
                    print("Birth date updated successfully.")
                elif choice == '4':
                    new_description = input("Enter your new last name: ")
                    cursor.execute("UPDATE historical_figure SET death_date = %s WHERE id = %s",
                                   (new_description, user_id))
                    connection.commit()
                    print("Death date updated successfully.")
                elif choice == '0':
                    print("Returning to the main menu.")
                    return
                else:
                    print("Invalid choice. Please try again.")
        except Exception as e:
            print(f"Error: Unable to edit profile\n{e}")


def view_action_table(user_id):
    try:
        with connection.cursor() as cursor:
            cursor.execute("SELECT a.id, a.action_time, a.user_id, a_t.name "
                           "FROM action a JOIN action_type a_t ON a.action_type_id = a_t.id")
            actions = cursor.fetchall()

            if not actions:
                print("No actions found.")
            else:
                print("\nList of actions:")
                print("{:<5} {:<30} {:<10} {:<20}".format("ID", "Action Time", "User ID", "Action Type"))
                for action in actions:
                    print("{:<5} {:<30} {:<10} {:<20}".format(action[0], str(action[1]), action[2], action[3]))

    except Exception as e:
        print(f"Error viewing action table: {e}")


def main():
    user_info = None
    user_role = None

    while True:
        print("\nMenu:")

        if user_info:
            print("3. View profile")
            print("4. Edit profile")
            print("5. View collections")
            print("6. View countries")
            print("7. View historical figures")
            if user_role in [1, 2]:
                print("8. Edit collection")
                print("9. Edit country")
                print("10. Edit historical_figure")
                if user_role == 1:
                    print("11. Delete user")
                    print("12. Change user role")
                    print("13. Users history")
            print("0. Logout")
        else:
            print("1. Register")
            print("2. Login")
            print("0. Exit")

        choice = input("Enter your choice: ")

        if choice == '1' and not user_info:
            user_info = register_user()
        elif choice == '2' and not user_info:
            user_info = login_user()
            if user_info:
                user_role = check_role(user_info[0])
        elif user_info and choice in ['3', '4', '5', '6', '7']:
            menu_options_common = {
                '3': view_profile,
                '4': edit_profile,
                '5': view_collections,
                '6': view_countries,
                '7': view_historical_figures
            }
            menu_options_common[choice](user_info[0])

        elif user_info and choice in ['8', '9', '10', '11', '12', '13']:
            if user_role in [1, 2]:
                menu_options_archivist = {
                    '8': edit_collection,
                    '9': edit_country,
                    '10': edit_historical_figure
                }
                if choice in menu_options_archivist:
                    menu_options_archivist[choice](user_info[0])

                if user_role == 1:
                    menu_options_admin = {
                        '11': delete_user_by_id,
                        '12': change_user_role,
                        '13': view_action_table
                    }
                    if choice in menu_options_admin:
                        menu_options_admin[choice](user_info[0])
            else:
                print("Invalid choice. Please try again.")

        elif user_info and choice == '0':
            print("Logging out.")
            user_info = None
            user_role = None
        elif not user_info and choice == '0':
            print("Exiting the program.")
            break
        else:
            print("Invalid choice. Please try again.")


if __name__ == "__main__":
    main()
