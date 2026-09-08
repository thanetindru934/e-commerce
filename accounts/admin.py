from django.contrib import admin
from .models import GuestEmail, User
from .forms import UserAdminCreationForm, UserAdminChangeForm
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin 
# Register your models here.
class UserAdmin(BaseUserAdmin):
    form = UserAdminChangeForm
    add_form = UserAdminCreationForm
    
    list_display = ('email','admin')
    list_filter = ('admin','staff','active')
    fieldsets = (
        (None,{'fields':('email','password')}),
        ('Personal Info',{'fields':('full_name',)}),
        ('Permissions',{'fields':('active','staff','admin')}),        
    )
    add_fieldsets = (
    (None,{'classes':('wide'),
           'fields':('email','password1','password2')}
    
           ),    
    )
    search_fields = ('email','full_name')
    ordering = ('email',)
    filter_horizontal = ()

class GuestEmailAdmin(admin.ModelAdmin):
    search_fields = ['email']
    class Meta:
        model = GuestEmail
        
        
admin.site.register(GuestEmail,GuestEmailAdmin)
admin.site.register(User,UserAdmin)

#admin.site.unregister(Group)