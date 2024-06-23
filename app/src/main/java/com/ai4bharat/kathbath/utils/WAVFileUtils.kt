package com.ai4bharat.kathbath.utils

import android.media.AudioFormat
import java.io.DataOutputStream
import java.io.RandomAccessFile

object WAVFileUtils {

    fun writeWavFileHeader(
        scratchRecordingFile: DataOutputStream, audioEncoding: Int,
        samplingRate: Int
    ): DataOutputStream {
        val bitsPerSample = if (audioEncoding == AudioFormat.ENCODING_PCM_16BIT) 16 else 8
        val bytesPerSample = bitsPerSample / 8

        writeString(scratchRecordingFile, "RIFF")
        writeInt(scratchRecordingFile, 0)
        writeString(scratchRecordingFile, "WAVE")
        writeString(scratchRecordingFile, "fmt ")
        writeInt(scratchRecordingFile, 16)
        writeShort(scratchRecordingFile, 1.toShort())
        writeShort(scratchRecordingFile, 1.toShort())
        writeInt(scratchRecordingFile, samplingRate)
        writeInt(scratchRecordingFile, samplingRate * bytesPerSample)
        writeShort(scratchRecordingFile, bytesPerSample.toShort())
        writeShort(scratchRecordingFile, bitsPerSample.toShort())
        writeString(scratchRecordingFile, "data")
        writeInt(scratchRecordingFile, 0)

        return scratchRecordingFile
    }

    fun writeString(output: DataOutputStream, value: String) {
        for (element in value) {
            output.writeBytes(element.toString())
        }
    }

    fun writeShort(output: DataOutputStream, value: Short) {
        output.write(value.toInt() shr 0)
        output.write(value.toInt() shr 8)
    }

    fun writeInt(output: DataOutputStream, value: Int) {
        output.write(value shr 0)
        output.write(value shr 8)
        output.write(value shr 16)
        output.write(value shr 24)
    }

    fun writeIntAtLocation(output: RandomAccessFile, value: Int, location: Long) {
        val data = ByteArray(4)
        data[0] = (value shr 0).toByte()
        data[1] = (value shr 8).toByte()
        data[2] = (value shr 16).toByte()
        data[3] = (value shr 24).toByte()
        output.seek(location)
        output.write(data)
    }
}