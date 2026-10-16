from django.contrib import admin
from .models import ContactMessage


@admin.register(ContactMessage)
class ContactMessageAdmin(admin.ModelAdmin):
    list_display = ("full_name", "email", "created_at")
    search_fields = ("full_name", "email", "content")
    list_filter = ("created_at",)
    readonly_fields = ("full_name", "email", "content", "created_at")