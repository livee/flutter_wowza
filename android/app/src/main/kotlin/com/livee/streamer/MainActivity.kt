package com.livee.streamer

import android.app.Activity
import android.content.Intent
import android.util.Log
import android.preference.PreferenceManager
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    private val CHANNEL = "test_activity"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "helloFromNativeCode") {
                try {
                    val mSharedPreferences = PreferenceManager.getDefaultSharedPreferences(activity);
                    val editor = mSharedPreferences.edit()
                    editor.putString("wz_live_host_address", call.argument<String>("host_address"))
                    editor.putString("wz_live_port_number", "" + call.argument<Integer>("port_number"))
                    editor.putString("wz_live_app_name", call.argument<String>("app_name"))
                    editor.putString("wz_live_stream_name", call.argument<String>("stream_name"))
                    editor.putBoolean("wz_video_resize_to_aspect", true)
                    editor.apply()

                    val intent = Intent(this, CameraActivity::class.java)
                    //intent.putExtra("host_address", call.argument<String>("host_address"));
                    //intent.putExtra("port_number", call.argument<String>("port_number"));
                    //intent.putExtra("app_name", call.argument<String>("app_name"));
                    //intent.putExtra("stream_name", call.argument<String>("stream_name"));
                    startActivityForResult(intent, 100)
                    //val greetings = helloFromNativeCode()
                    //result.success(greetings)
                } catch (ex: Exception) {
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, result: Int, intent: Intent?) {
        if (requestCode != 9689)
            return super.onActivityResult(requestCode, result, intent)
        if (result == Activity.RESULT_OK) {
            //_result.success(mapOf(intent!!.getStringExtra("address") to
            //        listOf(intent.getDoubleExtra("latitude", 0.0),
            //                intent.getDoubleExtra("longitude", 0.0))))
        }
        //else
        //_result.success(null)
    }

    private fun helloFromNativeCode(): String {
        return "Hello from Native Android Code2"
    }
}