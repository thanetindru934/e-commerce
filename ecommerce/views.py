
# from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.contrib import messages

from .forms import ContactForm
from .models import ContactMessage


def home_page(request):
    context = {
        "title": "Welcome to eCommerce",
        "content": "Browse our products and enjoy a simple and convenient online shopping experience.",
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

    if request.method == "POST" and contact_form.is_valid():
        print(contact_form.cleaned_data)

        ContactMessage.objects.create(
            full_name=contact_form.cleaned_data["fullname"],
            email=contact_form.cleaned_data["email"],
            content=contact_form.cleaned_data["content"],
        )

        messages.success(
            request,
            "Message Sent Successfully! Thank you for contacting us. "
            "Your message has been received successfully."
        )

        return redirect("contact")

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
