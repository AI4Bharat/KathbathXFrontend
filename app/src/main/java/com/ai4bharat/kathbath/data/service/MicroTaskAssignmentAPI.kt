package com.ai4bharat.kathbath.data.service

import com.ai4bharat.kathbath.BuildConfig
import com.ai4bharat.kathbath.data.model.karya.KaryaFileRecord
import com.ai4bharat.kathbath.data.model.karya.MicroTaskAssignmentRecord
import com.ai4bharat.kathbath.data.remote.response.GetAssignmentsResponse
import okhttp3.MultipartBody
import okhttp3.ResponseBody
import retrofit2.Response
import retrofit2.http.*

interface MicroTaskAssignmentAPI {

  @PUT("/assignments")
  suspend fun submitCompletedAssignments(
    @Header("karya-id-token") idTokenHeader: String,
    @Body updates: List<MicroTaskAssignmentRecord>,
    @Header("version") version: String = BuildConfig.VERSION_CODE.toString(),

  ): Response<List<String>>

  @PUT("/skipped_expired_assignments")
  suspend fun submitSkippedAssignments(
    @Header("karya-id-token") idToken: String,
    @Body ids: List<MicroTaskAssignmentRecord>
  ): Response<List<String>>

  @GET("/assignments")
  suspend fun getNewAssignments(
    @Header("karya-id-token") idTokenHeader: String,
    @Query("from") from: String,
    @Header("version") version: String = BuildConfig.VERSION_CODE.toString(),
    @Query("type") type: String = "new",
  ): Response<GetAssignmentsResponse>

  @GET("/assignments")
  suspend fun getVerifiedAssignments(
    @Header("karya-id-token") idTokenHeader: String,
    @Query("from") from: String,
    @Header("version") version: String = BuildConfig.VERSION_CODE.toString(),
    @Query("type") type: String = "verified",
  ): Response<List<MicroTaskAssignmentRecord>>

  @Multipart
  @POST("/assignment/{id}/output_file")
  suspend fun submitAssignmentOutputFile(
    @Header("karya-id-token") idTokenHeader: String,
    @Path("id") id: String,
    @Part json: MultipartBody.Part,
    @Part file: MultipartBody.Part,
  ): Response<KaryaFileRecord>

  @GET("/assignment/{id}/input_file")
  suspend fun getInputFile(
    @Header("karya-id-token") idToken: String,
    @Path("id") assignmentId: String,
  ): Response<ResponseBody>
}
