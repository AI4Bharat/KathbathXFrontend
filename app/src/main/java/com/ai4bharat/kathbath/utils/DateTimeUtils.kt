package com.ai4bharat.kathbath.utils

import java.text.SimpleDateFormat
import java.util.*

object DateTimeUtils {

    fun getCurrentDate(): String {
        val date = Date()
        val simpleDateTimeFormatter =
            SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", Locale.US)
        SimpleDateFormat.getDateTimeInstance()
        simpleDateTimeFormatter.timeZone = TimeZone.getTimeZone("UTC")
        return simpleDateTimeFormatter.format(date)
    }

    fun convert24to12(time24: String): String {
        return try {
            val _24SDF = SimpleDateFormat("HH:mm", Locale.US)
            val _12SDF = SimpleDateFormat("hh:mm a", Locale.US)
            val date24 = _24SDF.parse(time24)
            _12SDF.format(date24)
        } catch (e: Exception) {
            time24
        }
    }

    fun millisecondToTime(millisecond: Double): String {
        val totalSeconds: Double = millisecond / 1000
        var seconds = (totalSeconds % 60).toInt().toString()
        val minutes = (totalSeconds / 60).toInt().toString()

        if (seconds.length < 2) seconds = "0$seconds"
        return "$minutes:$seconds"
    }

    fun millisecondToPercentage(current: Double, totalDuration: Double): Int {
        if (totalDuration == 0.0 || current == 0.0) {
            return 0
        }

        return ((current / totalDuration) * 100).toInt()
    }

}
