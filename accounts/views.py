from django.contrib.auth import (
    authenticate,
    get_user_model,
    login,
    logout,
)
from django.shortcuts import redirect
from django.utils.http import url_has_allowed_host_and_scheme
from django.views.generic import CreateView, FormView

from .forms import GuestForm, LoginForm, RegisterForm
from .models import GuestEmail


User = get_user_model()


def redirect_is_allowed(request, redirect_path):
    return url_has_allowed_host_and_scheme(
        url=redirect_path,
        allowed_hosts={request.get_host()},
        require_https=request.is_secure(),
    )


def guest_register_view(request):
    form = GuestForm(request.POST or None)
    context = {"form": form}

    next_ = request.GET.get("next")
    next_post = request.POST.get("next")
    redirect_path = next_ or next_post or None

    if form.is_valid():
        email = form.cleaned_data.get("email")

        new_guest_email = GuestEmail.objects.create(
            email=email
        )

        request.session["guest_email_id"] = new_guest_email.id

        if redirect_is_allowed(request, redirect_path):
            return redirect(redirect_path)

        return redirect("/register/")

    return redirect("/register/")


def logout_view(request):
    logout(request)
    return redirect("login")


class LoginView(FormView):
    form_class = LoginForm
    template_name = "accounts/login.html"
    success_url = "/"

    def form_valid(self, form):
        request = self.request

        next_ = request.GET.get("next")
        next_post = request.POST.get("next")
        redirect_path = next_ or next_post or None

        email = form.cleaned_data.get("email")
        password = form.cleaned_data.get("password")

        user = authenticate(
            request,
            username=email,
            password=password,
        )

        if user is not None:
            login(request, user)

            try:
                del request.session["guest_email_id"]
            except KeyError:
                pass

            if redirect_is_allowed(request, redirect_path):
                return redirect(redirect_path)

            return redirect("/")

        return self.form_invalid(form)


class RegisterView(CreateView):
    form_class = RegisterForm
    template_name = "accounts/register.html"
    success_url = "/login/"


# def register_page(request):
#     form = RegisterForm(request.POST or None)
#     context = {
#         "form": form
#     }
#
#     if form.is_valid():
#         form.save()
#         return redirect("/login")
#
#     return render(
#         request,
#         "accounts/register.html",
#         context
#     )


# def login_page(request):
#     form = LoginForm(request.POST or None)
#     context = {"form": form}
#
#     next_ = request.GET.get("next")
#     next_post = request.POST.get("next")
#     redirect_path = next_ or next_post or None
#
#     if form.is_valid():
#         email = form.cleaned_data.get("email")
#         password = form.cleaned_data.get("password")
#
#         user = authenticate(
#             request,
#             username=email,
#             password=password,
#         )
#
#         if user is not None:
#             login(request, user)
#
#             try:
#                 del request.session["guest_email_id"]
#             except KeyError:
#                 pass
#
#             if redirect_is_allowed(request, redirect_path):
#                 return redirect(redirect_path)
#
#             return redirect("/")
#
#         print("Error")
#
#     return render(
#         request,
#         "accounts/login.html",
#         context
#     )