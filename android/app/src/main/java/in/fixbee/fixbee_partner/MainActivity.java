package in.fixbee.fixbee_partner;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodChannel;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.app.NotificationManager;
import android.app.NotificationChannel;
import android.net.Uri;
import android.media.AudioAttributes;
import android.content.ContentResolver;


public class MainActivity extends FlutterActivity {

    //Notification channel
     String CHANNEL = "fixbee.in/order_notification_channel";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine);
      super.configureFlutterEngine(flutterEngine);
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
              .setMethodCallHandler(
                      (call, result) -> {
                        if(call.method.equals("createNotificationChannel")){
                          String id = call.argument("id");
                          String name = call.argument("name");
                          String description = call.argument("description");
                          boolean created= createNotificationChannel(id, name, description);
                          if(created)
                            result.success(created);
                          else
                            result.error("ERROR_CHANNEL", "Error", null);
                        }
                        else{
                          result.notImplemented();
                        }
                      }
              );
    }

    private boolean createNotificationChannel(String id, String name, String description) {

      if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
        int importance = NotificationManager.IMPORTANCE_HIGH;
        NotificationChannel channel = new NotificationChannel(id, name, importance);
        channel.setDescription(description);
        channel.setVibrationPattern(new long[]{100, 200, 500, 200, 100});
        channel.enableVibration(true);
        NotificationManager notificationManager = getSystemService(NotificationManager.class);
        Uri uri = Uri.parse(ContentResolver.SCHEME_ANDROID_RESOURCE+"://"+this.getPackageName()+"/raw/flute_order");
        AudioAttributes att = new AudioAttributes.Builder()
                  .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                  .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
                  .build();
        channel.setSound(uri,att);
        notificationManager.createNotificationChannel(channel);
        return true;
      }
      else{
        return false;
      }
    }


}
