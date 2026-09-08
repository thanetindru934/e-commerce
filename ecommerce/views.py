# from django.http import HttpResponse
from django.shortcuts import render  # , redirect

from .forms import ContactForm


def home_page(request):
    context = {
        "title": "Home Page",
        "content": "you are viewing home page",
    }

    print("Session key - %s " % request.session.session_key)

    if request.user.is_authenticated:
        context["premium"] = "Welcome"

    return render(
        request,
        "home_page.html",
        context,
    )


def about_page(request):
    context = {
        "title": "About Page",
        "content": "you are viewing about page",
    }

    return render(
        request,
        "home_page.html",
        context,
    )


def contact_page(request):
    contact_form = ContactForm(request.POST or None)

    context = {
        "title": "Contact Page",
        "content": "you are viewing contact page",
        "form": contact_form,
    }

    if contact_form.is_valid():
        print(contact_form.cleaned_data)

    if request.method == "POST":
        print(request.POST)
        print(request.POST.get("fullname"))
        print(request.POST.get("email"))
        print(request.POST.get("content"))

        # name = request.POST.get("fullname")
        # email = request.POST.get("email")
        # content = request.POST.get("content")
        #
        # context = {
        #     "title": "Contact Page",
        #     "content": "you are viewing contact page",
        #     "name": name,
        #     "email": email,
        #     "cont": content,
        #     "form": contact_form,
        # }

    return render(
        request,
        "contact/view.html",
        context,
    )