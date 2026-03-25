from django.shortcuts import render, redirect
from django.contrib import messages
from .forms import ContactForm

def home(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            name = form.cleaned_data['name']
            email = form.cleaned_data['email']
            message = form.cleaned_data['message']
            
            # Здесь можно добавить отправку email или сохранение в БД
            messages.success(request, f'Спасибо, {name}! Ваше сообщение отправлено. Я свяжусь с вами на {email}')
            return redirect('home')
    else:
        form = ContactForm()
    
    return render(request, 'main/home.html', {'form': form})
