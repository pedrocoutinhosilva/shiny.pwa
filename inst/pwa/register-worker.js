if('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('<<location>>service-worker.js', { scope: '<<location>>' })
    .then(function() { console.log('Service Worker Registered'); });
}
