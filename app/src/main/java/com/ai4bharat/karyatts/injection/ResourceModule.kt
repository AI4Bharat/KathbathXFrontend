package com.ai4bharat.karyatts.injection

import android.content.Context
import com.ai4bharat.karyatts.data.manager.ResourceManager
import com.ai4bharat.karyatts.data.repo.LanguageRepository
import com.ai4bharat.karyatts.injection.qualifier.FilesDir
import dagger.Module
import dagger.Provides
import dagger.Reusable
import dagger.hilt.InstallIn
import dagger.hilt.android.qualifiers.ApplicationContext
import dagger.hilt.components.SingletonComponent

@Module
@InstallIn(SingletonComponent::class)
class ResourceModule {

  @Provides
  @Reusable
  @FilesDir
  fun providesContextDirectoryPath(@ApplicationContext context: Context): String =
    context.filesDir.path

  @Provides
  @Reusable
  fun providesResourceManager(
    languageRepository: LanguageRepository,
    @FilesDir filesDirPath: String
  ): ResourceManager {
    return ResourceManager(languageRepository, filesDirPath)
  }
}
