if('serviceWorker' in navigator) {
  navigator.serviceWorker
    .register('{{location}}pwa-service-worker.js', { scope: '{{location}}' })
    .then(function() { console.log('Service Worker Registered'); });
}
