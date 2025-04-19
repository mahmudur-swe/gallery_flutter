package com.example.gallery_flutter

import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Log
import android.util.Size
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import androidx.core.net.toUri
import java.io.OutputStream

const val CHANNEL = "gallery_flutter/photos"
const val GET_ALL_PHOTOS_METHOD = "getPhotos"
const val GET_THUMBNAIL_BYTES_METHOD = "getThumbnailBytes"
const val GET_FULL_FRAME_IMAGE_METHOD = "getFullFrameImage"
const val SAVE_PHOTO_METHOD = "savePhoto"

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


                val resolution = call.argument<String>("resolution") ?: "high"

                val bytes = getThumbnailBytes(this, uri, resolution)
                if (bytes != null) {
                    result.success(bytes)
                } else {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }
            } else if (call.method == GET_FULL_FRAME_IMAGE_METHOD) {
                val uri = call.argument<String>("uri") ?: ""
                val bytes = getFullFrameImage(this, uri)
                if (bytes != null) {
                    result.success(bytes)
                } else {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }
            }

            else if (call.method == SAVE_PHOTO_METHOD) {

                val imageBytes = call.argument<ByteArray>("imageBytes")

                if(imageBytes == null) {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }

                try {
                    val success = savePhoto(this, imageBytes!!)
                    result.success(success)
                }catch (e: Exception) {
                    result.error("UNAVAILABLE", "Could not save photo", null)
                }

            }

            else {
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

private fun getFullFrameImage(context: Context, uriString: String): ByteArray? {
    return try {
        val uri = uriString.toUri()
        context.contentResolver.openInputStream(uri)?.use { input ->
            input.readBytes() // ✅ full resolution
        }
    } catch (e: Exception) {
        e.printStackTrace()
        null
    }
}


private fun getThumbnailBytes(context: Context, uriString: String, resolution: String): ByteArray? {
    return try {

        val targetSize = when (resolution) {
            "low" -> Size(25, 25)
            "high" -> Size(300, 300)
            else -> Size(100, 100)
        }

        val quality = when (resolution) {
            "low" -> 40
            "high" -> 90
            else -> 80
        }

        val uri = uriString.toUri()

        val bitmap = when {
            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                context.contentResolver.loadThumbnail(uri, targetSize, null)
            }
            else -> {
                decodeThumbnail(context, uri, targetSize.width, targetSize.height)
            }
        }

        val stream = ByteArrayOutputStream()
        bitmap?.compress(Bitmap.CompressFormat.JPEG, quality, stream)
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

fun savePhoto(context: Context, imageBytes : ByteArray): Boolean {
    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
    val filename = "IMG_${System.currentTimeMillis()}.jpg"

    val resolver = context.contentResolver
    val contentValues = ContentValues().apply {
        put(MediaStore.Images.Media.DISPLAY_NAME, filename)
        put(MediaStore.Images.Media.MIME_TYPE, "image/jpeg")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            put(MediaStore.Images.Media.RELATIVE_PATH, Environment.DIRECTORY_PICTURES)
        }
    }

    val imageUri = resolver.insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues)
    imageUri?.let {
        val outputStream: OutputStream? = resolver.openOutputStream(it)
        outputStream.use { stream ->
            if (stream != null) {
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            }
        }
        return true
    } ?: run {
        throw Exception("Failed to save image")
    }

}

