/**
 * OpenCPS is the open source Core Public Services software
 * Copyright (C) 2016-present OpenCPS community
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>
 */

package org.opencps.backend.util;

import java.util.Calendar;
import java.util.Random;

import org.opencps.dossiermgt.model.Dossier;
import org.opencps.dossiermgt.service.DossierLocalServiceUtil;

import com.liferay.portal.kernel.util.StringPool;
import com.liferay.portal.kernel.util.StringUtil;
import com.liferay.portal.kernel.util.Validator;


/**
 * @author khoavd
 *
 */
public class DossierNoGenerator {
	
	public static void main(String[] args) {

	    String numberString = genaratorNoReception("{yyyy}{dd}{mm}{%-ABC1111/%}{nnnnnnnnnnnnnnnn}", 43213);
	    
	    System.out.println(numberString);
    }
	
	
	/**
	 * @param pattern
	 * @return
	 */
	public static String genaratorNoReception(String pattern, long dossierId) {
		
		String noReception = _genaratorNoReception(pattern, dossierId);
		
		Dossier dossier = null;
		
		try {
			dossier = DossierLocalServiceUtil.getDossierByReceptionNo(noReception);
        }
        catch (Exception e) {
	        
        }
		
		if (Validator.isNotNull(dossier)) {
			noReception = genaratorNoReception(pattern, dossierId);
		}
		
		return noReception;
	}
	
	/**
	 * Generate noReception with pattern
	 * 
	 * @param pattern
	 * @return
	 */
	private static String _genaratorNoReception(String pattern, long dossierId) {
		
		String noReception = StringPool.BLANK;
		
		//pattern = StringUtil.lowerCase(pattern);
		pattern = StringUtil.trim(pattern, ' ');
		
		StringBuffer sbNoReception = new StringBuffer(pattern);
		
		Calendar cal = Calendar.getInstance();
		
		String strYearTypeOne = Integer.toString(cal.get(Calendar.YEAR));
		String strYearTypeTwo = Integer.toString(cal.get(Calendar.YEAR)).substring(2);
		
		String strMonth =
		    (cal.get(Calendar.MONTH) + 1) < 10
		        ? "0" + Integer.toString(cal.get(Calendar.MONTH) + 1)
		        : Integer.toString(cal.get(Calendar.MONTH) + 1);
		String strDay =
		    cal.get(Calendar.DAY_OF_MONTH) < 10
		        ? "0" + Integer.toString(cal.get(Calendar.DAY_OF_MONTH))
		        : Integer.toString(cal.get(Calendar.DAY_OF_MONTH));
		
		if (_validateParttern(pattern)) {
			
			String specialChar = _getSpecicalChar(pattern);
			
			String serialNumber = _serialNumberAutoIncrement(pattern, dossierId);
			
			sbNoReception.replace(pattern.indexOf('n') - 1 , pattern.lastIndexOf('n') + 2, serialNumber);
			
			try {
				sbNoReception.replace(pattern.indexOf('%') - 1, pattern.lastIndexOf('%') + 3, specialChar);

			} catch (Exception e) {
				
			}
			

			pattern = sbNoReception.toString();
			

			if (pattern.contains(FIX_YEAR_PATTERN_TYPE_1)) {
				pattern = StringUtil.replace(pattern, FIX_YEAR_PATTERN_TYPE_1, strYearTypeOne);
			}
			
			if (pattern.contains( FIX_YEAR_PATTERN_TYPE_2)) {
				pattern = StringUtil.replace(pattern, FIX_YEAR_PATTERN_TYPE_2, strYearTypeTwo);
			}
			
			if (pattern.contains(FIX_MONTH_PATTERN)) {
				pattern = StringUtil.replace(pattern, FIX_MONTH_PATTERN, strMonth);
			}
			
			if (pattern.contains(FIX_DAY_PATTERN)) {
				pattern = StringUtil.replace(pattern, FIX_DAY_PATTERN, strDay);
			}
			
			noReception = pattern;
			
		} else {
			
			StringBuffer sbNoReceptionDefault = new StringBuffer();
			
			String serialNumber = noGenarator(FIX_DEFAULT_SERIAL_NUMBER);
			
			sbNoReceptionDefault.append(strYearTypeOne);
			sbNoReceptionDefault.append(strMonth);
			sbNoReceptionDefault.append(strDay);
			sbNoReceptionDefault.append(serialNumber);
			
			noReception = sbNoReceptionDefault.toString();
			
		}
		
		return noReception;
	}
	
	private static boolean _validateParttern(String pattern) {
		boolean isValidator = true;
		
		//pattern = StringUtil.lowerCase(pattern);
		
		int countSpecial = StringUtil.count(pattern, "%");
		
		if (countSpecial > 2) {
			isValidator = false;
		}
		
/*		if (!pattern.contains(FIX_YEAR_PATTERN_TYPE_1) &&
		    !pattern.contains(FIX_YEAR_PATTERN_TYPE_2)) {
			isValidator = false;
		}
		
		if (!pattern.contains(FIX_MONTH_PATTERN)) {
			isValidator = false;
		}
		
		if (!pattern.contains(FIX_DAY_PATTERN)) {
			isValidator = false;
		}
		
		if (!pattern.contains(FIX_SERIAL_PATERN)) {
			isValidator = false;
		}
*/		
		return isValidator;
	}

	/**
	 * @return
	 */
	public static String noGenarator(int lengNumber) {
		char[] chars = "012346789".toCharArray();
		
		StringBuilder sb = new StringBuilder();
		
		Random random = new Random();
		
		for (int i = 0; i < lengNumber; i++) {
		    char c = chars[random.nextInt(chars.length)];
		    sb.append(c);
		}
		
		return sb.toString();
	}
	
	/**
	 * @param pattern
	 * @param dossierId
	 * @return
	 */
	private static String _serialNumberAutoIncrement(String pattern, long dossierId) {
		dossierId  = dossierId + 2;
		int numberSerial = StringUtil.count(pattern, "n");
		
		String strNumSerial = intToString(dossierId, numberSerial);
		
		return strNumSerial;
	}
	
	
	private static String _getSpecicalChar(String pattern) {
		String special = StringPool.BLANK;
		try {
			special = pattern.substring(pattern.indexOf('%')+1, pattern.lastIndexOf('%'));
        }
        catch (Exception e) {
	        // TODO: handle exception
        }
		
		return special;
	}
	
	/**
	 * @param number
	 * @param stringLength
	 * @return
	 */
	public static String intToString(long number, int stringLength) {

		int numberOfDigits = String.valueOf(number).length();
		int numberOfLeadingZeroes = stringLength - numberOfDigits;
		StringBuilder sb = new StringBuilder();
		if (numberOfLeadingZeroes > 0) {
			for (int i = 0; i < numberOfLeadingZeroes; i++) {
				sb.append("0");
			}
		}
		sb.append(number);
		return sb.toString();
	}

	
	public static final String FIX_YEAR_PATTERN_TYPE_1 = "{yyyy}";

	public static final String FIX_YEAR_PATTERN_TYPE_2 = "{yy}";
	
	public static final String FIX_MONTH_PATTERN = "{mm}";
	
	public static final String FIX_DAY_PATTERN = "{dd}";
	
	public static final String FIX_SERIAL_PATERN = "{nn";
	
	public static final int FIX_DEFAULT_SERIAL_NUMBER = 6;
	
}
