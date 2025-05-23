package com.example.gallery_flutter

import android.app.ActivityManager
import android.content.ContentUris
import android.content.ContentValues
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.util.Size
import androidx.core.net.toUri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.OutputStream

const val CONFIG_CHANNEL = "gallery_flutter/config"

const val PHOTO_CHANNEL = "gallery_flutter/photos"
const val GET_ALL_PHOTOS_METHOD = "getPhotos"
const val GET_THUMBNAIL_BYTES_METHOD = "getThumbnailBytes"
const val GET_FULL_FRAME_IMAGE_METHOD = "getFullFrameImage"
const val SAVE_PHOTO_METHOD = "savePhoto"

const val GET_TOTAL_MEMORY_METHOD = "getTotalMemory"

class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        super.configureFlutterEngine(flutterEngine)

        /** Method channel to get total memory **/
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CONFIG_CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == GET_TOTAL_MEMORY_METHOD) {
                    val activityManager =
                        getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
                    val memoryInfo = ActivityManager.MemoryInfo()
                    activityManager.getMemoryInfo(memoryInfo)
                    val totalMemMB = memoryInfo.totalMem / (1024 * 1024)
                    result.success(totalMemMB.toInt())
                } else {
                    result.notImplemented()
                }
            }
        /** Method channel to for fetching photos **/
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PHOTO_CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == GET_ALL_PHOTOS_METHOD) {

                /** Get all photos from the native platform **/
                val photoList = getPhotos(this)

                result.success(photoList)

            } else if (call.method == GET_THUMBNAIL_BYTES_METHOD) {
                val uri = call.argument<String>("uri") ?: ""

                val resolution = call.argument<String>("resolution") ?: "high"

                /** Get thumbnail bytes from the native platform for low and high resolution **/
                val bytes = getThumbnailBytes(this, uri, resolution)

                if (bytes != null) {
                    result.success(bytes)
                } else {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }

            } else if (call.method == GET_FULL_FRAME_IMAGE_METHOD) {
                val uri = call.argument<String>("uri") ?: ""

                /** Get full frame image from the native platform **/
                val bytes = getFullFrameImage(this, uri)

                if (bytes != null) {
                    result.success(bytes)
                } else {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }

            } else if (call.method == SAVE_PHOTO_METHOD) {

                /** Save photo to the gallery. Receives the image bytes **/

                val imageBytes = call.argument<ByteArray>("imageBytes")

                if (imageBytes == null) {
                    result.error("UNAVAILABLE", "Could not load thumbnail", null)
                }

                try {
                    val success = savePhoto(this, imageBytes!!)
                    result.success(success)
                } catch (e: Exception) {
                    result.error("UNAVAILABLE", "Could not save photo", null)
                }

            } else {
                result.notImplemented()
            }
        }
    }


}

/** Get all photos from the gallery **/
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

    context.contentResolver.query(uri, projection.toTypedArray(), null, null, sortOrder)
        ?.use { cursor ->
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

/** Get full frame image from the gallery **/
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


/** Get thumbnail bytes from the gallery **/
private fun getThumbnailBytes(context: Context, uriString: String, resolution: String): ByteArray? {
    return try {

        /** Size for low and high resolution **/
        val targetSize = when (resolution) {
            "low" -> Size(25, 25) // 25x25 for low resolution
            "high" -> Size(300, 300) // 300x300 for high resolution
            else -> Size(100, 100) // 100x100 for other
        }

        /** Quality for low and high resolution **/
        val quality = when (resolution) {
            "low" -> 40 // 40% quality for low resolution
            "high" -> 70 // 70% quality for high resolution
            else -> 80
        }

        val uri = uriString.toUri()

        val bitmap = when {


            Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q -> {
                /** Use loadThumbnail for Android 10+ **/
                context.contentResolver.loadThumbnail(uri, targetSize, null)
            }

            else -> {
                /** Use decodeThumbnail for Android 9 and below **/
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


/** Decode thumbnail from the gallery **/
fun decodeThumbnail(context: Context, uri: Uri, targetWidth: Int, targetHeight: Int): Bitmap? {
    return try {
        val inputStream = context.contentResolver.openInputStream(uri)
        val options = BitmapFactory.Options().apply {
            inJustDecodeBounds = true
        }

        BitmapFactory.decodeStream(inputStream, null, options)

        val scaleFactor = maxOf(
            1, minOf(
                options.outWidth / targetWidth,
                options.outHeight / targetHeight
            )
        )

        options.inJustDecodeBounds = false
        options.inSampleSize = scaleFactor

        val input = context.contentResolver.openInputStream(uri)
        BitmapFactory.decodeStream(input, null, options)
    } catch (e: Exception) {
        null
    }
}

/** Save photo to the gallery **/
fun savePhoto(context: Context, imageBytes: ByteArray): Boolean {
    val bitmap = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)

    /** Filename for the photo **/
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
                /** Compress the bitmap to JPEG **/
                bitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream)
            }
        }
        return true
    } ?: run {
        throw Exception("Failed to save image")
    }


}

