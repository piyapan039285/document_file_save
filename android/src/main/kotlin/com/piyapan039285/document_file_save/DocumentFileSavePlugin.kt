package com.piyapan039285.document_file_save

import android.R.attr
import android.content.ContentValues
import android.content.Context
import android.os.BatteryManager
import android.os.Build
import android.os.Environment
import android.os.Environment.DIRECTORY_DOWNLOADS
import android.os.ParcelFileDescriptor
import android.provider.MediaStore
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileOutputStream


/** DocumentFileSavePlugin */
class DocumentFileSavePlugin: FlutterPlugin, MethodCallHandler {
  private lateinit var context: Context

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "document_file_save")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "getBatteryPercentage") {
      val batteryManager = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
      val value = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
      result.success(value)
    } else if (call.method == "saveFile") {
      val data: ByteArray = call.argument("data")!!
      val fileName: String = call.argument("fileName")!!
      val mimeType: String = call.argument("mimeType")!!
      saveFile(data, fileName, mimeType)
      result.success(null)
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  private fun saveFile(data: ByteArray, fileName: String, mimeType: String) {
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
      Log.i("piyapan039285","save file using MediaStore")

      val values = ContentValues().apply {
        put(MediaStore.Downloads.DISPLAY_NAME, fileName)
        put(MediaStore.Downloads.MIME_TYPE, mimeType)
        put(MediaStore.Downloads.IS_PENDING, 1)
      }

      val resolver = context.contentResolver

      val collection = MediaStore.Downloads.getContentUri(MediaStore.VOLUME_EXTERNAL_PRIMARY)

      val itemUri = resolver.insert(collection, values)

      if (itemUri != null) {
        resolver.openFileDescriptor(itemUri, "w").use { it ->
          ParcelFileDescriptor.AutoCloseOutputStream(it).write(data)
        }
        values.clear()
        values.put(MediaStore.Downloads.IS_PENDING, 0)
        resolver.update(itemUri, values, null, null)
      }
    } else {
      Log.i("piyapan039285","save file using getExternalStoragePublicDirectory")
      val file = File(Environment.getExternalStoragePublicDirectory(DIRECTORY_DOWNLOADS), fileName)
      val fos = FileOutputStream(file)
      fos.write(attr.data)
      fos.close()
    }
  }
}
