
E-Commerce System
PRT582 – Software Engineering: Process and Tools | DRW Group 4
Charles Darwin University | 2026
Project Overview
This project is a Django-based e-commerce web application developed and evaluated as part of a software engineering group assessment. It supports product browsing, customer accounts, shopping carts, checkout, and administration. The team also conducted functional, usability, performance, and security testing.
Main Features
- Customer registration, login, and logout
- Product browsing and search
- Shopping cart management
- Checkout and order processing
- Contact form submission, with messages accessible through Django Admin
- Administration of products, customers, and orders
Technology Stack
- Python 3.13 (development environment)
- Django 5.2.x
- SQLite (development database)
- HTML, CSS, and JavaScript
- Robot Framework and SeleniumLibrary (functional testing)
- Lyssna (usability testing)
- Apache JMeter (performance testing)
- OWASP ZAP and Bandit (security testing)
Getting Started
Requirements
Install Python and Git. Use a virtual environment to isolate project dependencies.
Installation
1. Clone the repository (replace the placeholder with the actual repository URL):
   git clone <YOUR-REPOSITORY-URL>
   cd <YOUR-REPOSITORY-FOLDER>
2. Create and activate a virtual environment:
   Windows (PowerShell):
   python -m venv .venv
   .\.venv\Scripts\Activate.ps1
   macOS/Linux:
   python3 -m venv .venv
   source .venv/bin/activate
3. Install project dependencies:
   pip install -r requirements.txt
   If the repository does not contain requirements.txt, dependencies must be installed according to the actual project configuration; Django 5.2 alone may not cover all packages used.
4. Change into the folder containing manage.py. In the original project layout, this is the inner ecommerce folder:
   cd ecommerce
5. Apply existing database migrations:
   python manage.py migrate
6. Start the development server:
   python manage.py runserver
7. Open http://127.0.0.1:8000/ in your browser.
Note: If manage.py is already in your current directory, skip step 4. Do not run the Django development server as a production server.

Administrator Access
If you need a new local administrator account:
python manage.py createsuperuser
Then open http://127.0.0.1:8000/admin/ and sign in with the account you created.
Software Testing
Functional Testing
Automated functional testing was conducted using Robot Framework with SeleniumLibrary, covering registration, login, logout, contact form, product browsing, search, cart, checkout, and administration.
Metric	Result
Total tests	84
Passed	79
Failed	5
Skipped	0
Pass rate	94.05%


These figures reflect the final consolidated test run on 17 October 2026.
Non-Functional Testing
- Usability: Lyssna First Click and Five Second tests
- Performance: Apache JMeter load tests for homepage, cart, and checkout scenarios
- Security: OWASP ZAP dynamic scans and Bandit static analysis
Known Issues and Recommended Improvements
The final functional test run identified five failing scenarios:
1. Product search: A non-existent search term did not correctly exclude unrelated products (TC_SEARCH_02).
2. Checkout validation: An invalid order involving a negative-priced product could be completed (TC_CHECK_11).
3. Admin price validation: A negative product price was accepted (TC_ADMIN_13).
4. Cart pricing: A test expecting an updated price in an existing cart failed (TC_ADMIN_14).
5. Product pricing: A test expecting an updated price on the product page failed (TC_ADMIN_15).
Recommended improvements include server-side price validation, consistent price updates across carts and product pages, stronger checkout validation, and accurate search filtering. Performance testing also identified potential concurrency limitations associated with SQLite under load.
Project Structure
The original repository includes an outer project directory and an inner ecommerce directory containing the Django application and manage.py.
repository-root/
├── ecommerce/        # Django project directory (manage.py inside)
├── static_cdn/       # Static/media assets in the original layout
└── README.md
Other files and folders depend on the version of the project checked out.
Academic Context
Developed and tested for PRT582 – Software Engineering: Process and Tools, Charles Darwin University, 2026.
Notes
This repository is an academic project and may contain unresolved issues. Before any public deployment, review application security, environment configuration, secret management, database choice, and production hosting.
