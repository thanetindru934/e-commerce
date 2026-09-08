from django import forms
from django.forms.widgets import TextInput,EmailInput,Textarea, PasswordInput
from django.contrib.auth import get_user_model
User = get_user_model()

class ContactForm(forms.Form):
    "this is contact form rendered on contact.html"
    fullname = forms.CharField(widget=TextInput(
        attrs={
            "class":"form-control",
            "placeholder":"Your Name"
    }
        ))
    email    = forms.EmailField(widget=EmailInput(
        attrs={
            "class":"form-control",
            "placeholder":"Your Email"
    }
        ))
    content  = forms.CharField(widget=Textarea(
        attrs={
            "class":"form-control",
            "placeholder":"Your Content",
            "rows":"5"
    }
        ))
    
    def clean_email(self):
        email = self.cleaned_data.get('email')
        if not 'gmail.com'  in email:
            raise forms.ValidationError(f"{ email } is not a valid email")
        return email

