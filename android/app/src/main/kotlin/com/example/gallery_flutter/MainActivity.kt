package com.example.gallery_flutter

import android.content.ContentUris
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import androidx.core.net.toUri

const val CHANNEL = "gallery_flutter/photos"
const val GET_ALL_PHOTOS_METHOD = "getPhotos"
const val GET_THUMBNAIL_BYTES_METHOD = "getThumbnailBytes"

class MainActivity : FlutterActivity(){


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == GET_ALL_PHOTOS_METHOD) {

                val photoList = getPhotos(this)

                result.success(photoList)

            } else if (call.method == GET_THUMBNAIL_BYTES_METHOD) {
                val uri = call.argument<String>("uri") ?: ""
                val bytes = getThumbnailBytes(this, uri)
                if (bytes != null) {
                    result.success(bytes)
                } else {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

}

fun getPhotos(
    context: Context
): List<Map<String, Any?>> {
    val mediaList = mutableListOf<Map<String, Any?>>()

    val projection = mutableListOf(
        MediaStore.MediaColumns._ID,
        MediaStore.MediaColumns.DISPLAY_NAME
    )


    val sortOrder = "${MediaStore.MediaColumns.DATE_MODIFIED} DESC"

    val uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI

    context.contentResolver.query(uri, projection.toTypedArray(), null, null, sortOrder)?.use { cursor ->
        val idCol = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns._ID)
        val nameCol = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DISPLAY_NAME)


        while (cursor.moveToNext()) {
            val id = cursor.getLong(idCol)
            val name = cursor.getString(nameCol) ?: "Unknown"
            val uriWithId = ContentUris.withAppendedId(uri, id)

            mediaList.add(
                mapOf(
                    "id" to id,
                    "name" to name,
                    "uri" to uriWithId.toString()
                )
            )
        }
    }

    return mediaList
}


private fun getThumbnailBytes(context: Context, uriString: String): ByteArray? {
    return try {

        val uri = uriString.toUri()

        val bitmap = when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                context.contentResolver.loadThumbnail(uri, Size(200, 200), null)
            }
            else -> {
                decodeThumbnail(context, uri, 200, 200)
            }
        }

        val stream = ByteArrayOutputStream()
        bitmap?.compress(Bitmap.CompressFormat.JPEG, 70, stream)
        stream.toByteArray()
    } catch (e: Exception) {
        null
    }
}


fun decodeThumbnail(context: Context, uri: Uri, targetWidth: Int, targetHeight: Int): Bitmap? {
    return try {
        val inputStream = context.contentResolver.openInputStream(uri)
        val options = BitmapFactory.Options().apply {
            inJustDecodeBounds = true
        }

        BitmapFactory.decodeStream(inputStream, null, options)

        val scaleFactor = maxOf(1, minOf(
            options.outWidth / targetWidth,
            options.outHeight / targetHeight
        ))

        options.inJustDecodeBounds = false
        options.inSampleSize = scaleFactor

        val input = context.contentResolver.openInputStream(uri)
        BitmapFactory.decodeStream(input, null, options)
    } catch (e: Exception) {
        null
    }
}

