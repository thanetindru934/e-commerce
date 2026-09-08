from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import include, path
from django.views.generic import TemplateView

from accounts.views import (
    LoginView,
    RegisterView,
    guest_register_view,
    logout_view,
)
from addresses.views import (
    checkout_address_create_view,
    checkout_address_reuse_view,
)
from .views import about_page, contact_page, home_page


urlpatterns = [
    path("admin/", admin.site.urls),

    path("", home_page, name="home"),
    path("about/", about_page, name="about"),
    path("contact/", contact_page, name="contact"),

    path("login/", LoginView.as_view(), name="login"),
    path("logout/", logout_view, name="logout"),
    path("register/", RegisterView.as_view(), name="register"),
    path("register/guest/", guest_register_view, name="guest_register"),

    path(
        "checkout/address/create/",
        checkout_address_create_view,
        name="checkout_address_create",
    ),
    path(
        "checkout/address/reuse/",
        checkout_address_reuse_view,
        name="checkout_address_reuse",
    ),

    path(
        "bootstrap/",
        TemplateView.as_view(template_name="bootstrap.html"),
    ),

    path(
        "products/",
        include(("products.urls", "products"), namespace="products"),
    ),
    path(
        "cart/",
        include(("carts.urls", "cart"), namespace="cart"),
    ),
    path(
        "search/",
        include(("search.urls", "search"), namespace="search"),
    ),
]


if settings.DEBUG:
    urlpatterns += static(
        settings.STATIC_URL,
        document_root=settings.STATIC_ROOT,
    )
    urlpatterns += static(
        settings.MEDIA_URL,
        document_root=settings.MEDIA_ROOT,
    )