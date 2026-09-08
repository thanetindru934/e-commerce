from django.shortcuts import redirect
from django.utils.http import url_has_allowed_host_and_scheme

from billing.models import BillingProfile

from .forms import AddressForm
from .models import Address


def redirect_is_allowed(request, redirect_path):
    return url_has_allowed_host_and_scheme(
        url=redirect_path,
        allowed_hosts={request.get_host()},
        require_https=request.is_secure(),
    )


def checkout_address_create_view(request):
    form = AddressForm(request.POST or None)

    next_ = request.GET.get("next")
    next_path = request.POST.get("next")
    redirect_path = next_ or next_path or None

    if form.is_valid():
        print(request.POST)

        instance = form.save(commit=False)

        billing_profile, billing_profile_created = (
            BillingProfile.objects.new_or_get(request)
        )

        if billing_profile is not None:
            address_type = request.POST.get(
                "address_type",
                "shipping",
            )

            instance.billing_profile = billing_profile
            instance.address_type = address_type
            instance.save()

            request.session[
                address_type + "_address_id"
            ] = instance.id

            print(address_type + "_address_id")

        else:
            print("Error")
            return redirect("cart:checkout")

        if redirect_is_allowed(request, redirect_path):
            return redirect(redirect_path)

    return redirect("cart:checkout")


def checkout_address_reuse_view(request):
    if request.user.is_authenticated:
        context = {}

        next_ = request.GET.get("next")
        next_post = request.POST.get("next")
        redirect_path = next_ or next_post or None

        if request.method == "POST":
            shipping_address = request.POST.get(
                "shipping_address",
                None,
            )

            address_type = request.POST.get(
                "address_type",
                "shipping",
            )

            billing_profile, billing_profile_created = (
                BillingProfile.objects.new_or_get(request)
            )

            if shipping_address is not None:
                qs = Address.objects.filter(
                    billing_profile=billing_profile,
                    id=shipping_address,
                )

                if qs.exists():
                    request.session[
                        address_type + "_address_id"
                    ] = shipping_address

                if redirect_is_allowed(
                    request,
                    redirect_path,
                ):
                    return redirect(redirect_path)

    return redirect("cart:checkout")